import SwiftUI
import Factory

extension AuthScreen {
    func createAccount() {
        self.createError = nil
        guard self.createEmail.trim().notEmpty else {
            self.createError = "Email is empty"
            return
        }
        guard self.createPassword.trim().notEmpty else {
            self.createError = "Password is empty"
            return
        }
        guard self.createPasswordConfirmation.trim().notEmpty else {
            self.createError = "Password confirmation is empty"
            return
        }
        guard self.createPassword == self.createPasswordConfirmation else {
            self.createError = "Password and password confirmation do not match"
            return
        }
        
        authService.createUserEmail(email: self.createEmail, password: self.createPassword) { authDataResult, error in
            guard error == nil else {
                self.createError = error!.localizedDescription
                return
            }
            self.authService.currentUser = AppUser(authDataResult!.user)
        }
    }
}
