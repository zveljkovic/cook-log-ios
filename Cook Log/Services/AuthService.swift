import Foundation
import Factory
import FirebaseAuth

protocol User {
    var id: String {get}
}

class AppUser: User {
    private var firebaseUser: FirebaseAuth.User
    var id: String {
        get { self.firebaseUser.uid }
    }
    
    init(_ firebaseUser: FirebaseAuth.User) {
        self.firebaseUser = firebaseUser
    }
}

class AuthService: ObservableObject {
    @Published var currentUser: User?
    @Published var userDetermined = false
    
    @Injected(\.log) private var log
    private var authStateListenerHandle: NSObjectProtocol?
    
    
    func startAuthStateListener() {
        log.auth.debug("Starting auth state listener")
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { auth, user in
            self.log.auth.debug("Auth state changed: currentUser = \(auth.currentUser?.uid ?? "nil")")
            if (auth.currentUser == nil) {
                self.currentUser = nil
            } else {
                self.currentUser = AppUser(auth.currentUser!)
            }
            self.userDetermined = true
        }
    }
    
    func stopAuthStateListener() {
        log.auth.debug("Stopping auth state listener")
        guard authStateListenerHandle != nil else { return }
        Auth.auth().removeStateDidChangeListener(authStateListenerHandle!)
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            self.currentUser = nil
        } catch {
            log.auth.debug("Unable to logOut")
        }
        
    }
    
    func createUserEmail(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                self.log.auth.error("Create user with email returned error \(error!.localizedDescription)")
                completion(nil, error)
                return
            }
            self.log.auth.error("Create account with email had no error")
        }
    }
    
    func loginEmail(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                self.log.auth.error("Sign in with email returned error \(error!.localizedDescription)")
                completion(nil, error)
                return
            }
            self.log.auth.error("Sign in with email had no error")
            
        }
    }
}

extension Container {
    var authService: Factory<AuthService> { self { AuthService() }.singleton}
}
