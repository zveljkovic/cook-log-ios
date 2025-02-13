import Factory
import FirebaseStorage
import Foundation


class DataService: ObservableObject {
    private let storage = Storage.storage()
    @Injected(\.log) private var log
    @Injected(\.appConfig) private var appConfig
    @Injected(\.authService) private var authService
    @Published var userData: UserData?
    @Published var dataError: String?
    @Published var dataSaveError: String?
    
    @MainActor
    func saveData() async {
        if (self.userData == nil) {
            self.log.data.debug("Unexpected userData == nil")
            return
        }
        self.userData?.versionNumber += 1
        
        await MainActor.run {
            self.dataSaveError = nil
        }
        do {
            let jsonData = try JSONEncoder().encode(self.userData)
            try jsonData.write(to: userDataCacheFileUrl())
        
            let ref = firebaseReference()
            try ref.putFile(from: userDataCacheFileUrl())
            self.log.data.debug("Saving data success")
        } catch let err {
            self.log.data.debug("Saving data failure")
            self.log.data.error("\(err.localizedDescription)")
        }
    }
    
    @MainActor
    func loadData() async {
        self.log.data.debug("Loading data")
        if (self.userData != nil) {
            return
        }
        
        await MainActor.run {
            self.dataError = nil
        }
        let localUserData = loadUserDataFromLocalCache()
        let remoteUserData = await loadUserDataFromFirebase()
        
        if localUserData == nil && remoteUserData == nil {
            // We first started the app
            await _loadDataCaseNoData()
        } else if localUserData != nil && remoteUserData != nil {
            await _loadDataCaseBothData(localUserData!, remoteUserData!)
        } else if localUserData != nil && remoteUserData == nil {
            await _loadDataCaseOnlyLocal(localUserData!)
        } else if localUserData == nil && remoteUserData != nil {
            await _loadDataCaseOnlyRemote(remoteUserData!)
        }
    }
    
    private func _loadDataCaseNoData() async {
        let userData = UserData()
        do {
            try saveUserDataToLocalCache(userData)
        } catch let error {
            self.dataError = "Error saving to local cache. Error details: \(error.localizedDescription)"
        }
        do {
            try await saveUserDataToFirebase(userData)
        } catch let error {
            await MainActor.run {
                self.dataError = "Error saving to remote cache. Error details: \(error.localizedDescription)"
            }
        }
        await MainActor.run { self.userData = userData }
    }
    
    private func _loadDataCaseBothData(_ localUserData: UserData, _ remoteUserData: UserData) async {
        if localUserData.versionNumber == remoteUserData.versionNumber {
            // versions are the same nothing to be done
            await MainActor.run {
                self.userData = localUserData
            }
            return
        }

        if localUserData.versionNumber > remoteUserData.versionNumber {
            // local version is more recent than remote
            // save local to remote and use it
            do {
                try await saveUserDataToFirebase(localUserData)
            } catch let error {
                await MainActor.run {
                    self.dataError = "Error saving to remote cache. Error details: \(error.localizedDescription)"
                }
            }
            await MainActor.run {
                self.userData = localUserData
            }
            return
        }
        
        if localUserData.versionNumber < remoteUserData.versionNumber {
            // remote version is more recent than local
            // save remote to local and use it
            do {
                try saveUserDataToLocalCache(remoteUserData)
            } catch let error {
                await MainActor.run {
                    self.dataError = "Error saving to local cache. Error details: \(error.localizedDescription)"
                }
            }
            await MainActor.run {
                self.userData = remoteUserData
            }
            return
        }
    }
    
    private func _loadDataCaseOnlyLocal(_ localUserData: UserData) async {
        do {
            try await saveUserDataToFirebase(localUserData)
        } catch let error {
            await MainActor.run {
                self.dataError = "Error saving to remote cache. Error details: \(error.localizedDescription)"
            }
        }
        await MainActor.run {
            self.userData = localUserData
        }
    }
    
    private func _loadDataCaseOnlyRemote(_ remoteUserData: UserData) async {
        do {
            try saveUserDataToLocalCache(remoteUserData)
        } catch let error {
            await MainActor.run {
                self.dataError = "Error saving to local cache. Error details: \(error.localizedDescription)"
            }
        }
        await MainActor.run {
            self.userData = remoteUserData
        }
    }
    
    private func loadUserDataFromLocalCache() -> UserData? {
        do {
            self.log.data.info("Loading data from local cache")
            let data = try Data(contentsOf: userDataCacheFileUrl())
            return try JSONDecoder().decode(UserData.self, from: data)
        } catch let err {
            self.log.data.error("\(err.localizedDescription)")
            return nil
        }
    }
    
    private func loadUserDataFromFirebase() async -> UserData? {
        let ref = firebaseReference()
        self.log.data.info("Loading data from firebase \(ref)")
        do {
            let url = try await ref.writeAsync(toFile: userDataCacheFileUrl())
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(UserData.self, from: data)
        } catch let err {
            self.log.data.error("\(err.localizedDescription)")
            return nil
        }
    }

    private func userDataCacheFileUrl() throws -> URL {
        return try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("userDataCache.json")
    }
    
    func saveUserDataToLocalCache(_ userData: UserData) throws {
        self.log.data.info("Saving UserData to local cache")
        let data = try JSONEncoder().encode(userData)
        try data.write(to: userDataCacheFileUrl())
    }
    
    private func firebaseReference() -> StorageReference {
        let base = appConfig.firebaseStorageUrl
        let env = appConfig.env
        let uid = authService.currentUser!.id
        return storage.reference(forURL: "\(base)/\(env)/users/\(uid)/userData.json")
    }

    private func saveUserDataToFirebase(_ userData: UserData) async throws {
        let ref = firebaseReference()
        self.log.data.info("Saving UserData to Firebase \(ref)")
        // Data in memory
        let userData = try JSONEncoder().encode(userData)
        let metadata = try await ref.putDataAsync(userData)
        self.log.data.info("Uploaded user data of \(metadata.size) size")
    }

    
}

extension Container {
    var dataService: Factory<DataService> { self  { DataService() }.singleton }
}
