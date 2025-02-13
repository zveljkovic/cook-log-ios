import Foundation
import Factory

class AppConfig: Codable {
    private var version: Int = 1
    var env = "dev"
    var firebaseStorageUrl = "gs://cook-log-eacb6.appspot.com"
    
    init() {}
    
    func load() throws {
        let fileURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("config.json")

        var appData = AppConfig()
        do {
            let data = try Data(contentsOf: fileURL)
            appData = try JSONDecoder().decode(AppConfig.self, from: data)
        } catch {
        }
        
        self.version = appData.version
    }
}

extension Container {
    var appConfig: Factory<AppConfig> { self { AppConfig() }.singleton}
}
