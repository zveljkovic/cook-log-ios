import Factory
import FirebaseAuth
import FirebaseCore
import SwiftUI

struct RootView: View {
    @Injected(\.log) var log
    @InjectedObject(\.authService) var authService
    @InjectedObject(\.errorService) var errorService
    @StateObject var router = Router.shared
    
    func debugPath() -> String {
        do {
            let data = try JSONEncoder().encode(router.path.codable)
            return String(data: data, encoding: .utf8)!
        } catch {
            return ""
        }
    }
    
    var body: some View {
        VStack {
            NavigationStack(path: $router.path) {
                VStack{
                    if errorService.error != nil {
                        ErrorScreen(errorService.error!)
                    } else if !authService.userDetermined {
                        LoadingScreen()
                    } else if authService.currentUser == nil {
                        AuthScreen()
                    } else {
                        RecipeListScreen()
                    }
                }
                .navigationDestination(for: Recipe.self) { recipe in
                    RecipeScreen(recipe)//.navigationBarBackButtonHidden()
                }
                .navigationDestination(for: RecipeTextEntryModel.self) { model in
                    RecipeTextEntryScreen(model).navigationBarBackButtonHidden()
                }
                .navigationDestination(for: RecipeIngredientEntryModel.self) { model in
                    RecipeIngredientEntryScreen(model).navigationBarBackButtonHidden()
                }
            }
        }
    }
}

// #Preview {
//    RootView()
// }
//
