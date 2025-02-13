import Factory
import SwiftUI
import FirebaseAuth

struct StatusBar: View {
    @InjectedObject(\.networkService) var networkService
    
    var body: some View {
        HStack{
            Spacer()
            if !networkService.connected {
                Text("We are not connected").error()
            }
            Spacer()
        }
    }
}

#Preview("!connected !auth") {
    StatusBar()
}
#Preview("!connected auth") {
    Group {
        let _ = Container.shared.authService.register {
            let authService = AuthService()
            authService.currentUser = MockUser("id")
            return authService
        }
        StatusBar()
    }
}
#Preview("connected auth") {
    Group {
        let _ = Container.shared.authService.register {
            let authService = AuthService()
            authService.currentUser = MockUser("id")
            return authService
        }
        let _ = Container.shared.networkService.register {
            let networkService = NetworkService()
            networkService.connected = true
            return networkService
        }
        StatusBar()
    }
}
