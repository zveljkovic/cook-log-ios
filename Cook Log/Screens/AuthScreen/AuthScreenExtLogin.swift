import Factory
import FBSDKLoginKit
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import SwiftUI

extension AuthScreen {
    func login() {
        self.loginError = nil
        guard self.loginEmail.notEmpty else {
            self.loginError = "Email is empty"
            return
        }
        guard self.loginPassword.notEmpty else {
            self.loginError = "Password is empty"
            return
        }
        authService.loginEmail(email: self.loginEmail, password: self.loginPassword) { _, error in
            guard error == nil else {
                self.loginError = error!.localizedDescription
                return
            }
        }
    }
    
    func showEmailLogin() {
        withAnimation(.easeInOut(duration: 0.5)) {
            loginShowEmail = true
        }
    }
    
    func showAllLoginOptions() {
        withAnimation(.easeInOut(duration: 0.5)) {
            loginShowEmail = false
        }
    }

    func fbLogin() {
        let loginManager = LoginManager()
        let nonce = String.randomNoonce()
        // Ensure the configuration object is valid
        guard let configuration = LoginConfiguration(
            permissions: ["public_profile", "email"],
            tracking: .limited,
            nonce: nonce.sha256()
        )
        else {
            return
        }
        
        loginManager.logIn(configuration: configuration) { result in
            switch result {
            case .cancelled, .failed:
                // Handle error
                break
            case .success:
                let tokenString = AuthenticationToken.current?.tokenString
                // Get Firebase Auth
                let credential = OAuthProvider.credential(providerID: AuthProviderID.facebook,
                                                          idToken: tokenString!,
                                                          rawNonce: nonce)
                Auth.auth().signIn(with: credential) { _, error in
                    guard error == nil else {
                        self.loginError = error?.localizedDescription
                        self.log.auth.info("Facebook login error \(error!.localizedDescription)")
                        return
                    }
                    self.log.auth.info("Facebook login success")
                }
            }
        }
    }
    
    func googleLogin() {
        let vc = (UIApplication.shared.connectedScenes.first as! UIWindowScene)
            .windows.first!.rootViewController!
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { signInResult, error in
            guard error == nil else {
                self.loginError = error?.localizedDescription
                return
            }
            
            guard let result = signInResult else {
                self.loginError = "Google returned no result"
                return
            }
           
            // If sign in succeeded, display the app's main content View.
            self.log.auth.info("Google success")
            
            let user = result.user
            guard let idToken = user.idToken?.tokenString else {
                self.loginError = "Google Auth unable to access idToken"
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { _, _ in
            }
        }
    }
}
