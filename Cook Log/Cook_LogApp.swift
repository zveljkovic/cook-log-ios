import Factory
import GoogleSignIn
import FBSDKCoreKit
import FirebaseAuth
import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    @Injected(\.authService) private var authService
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Facebook
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        FirebaseApp.configure()
        authService.startAuthStateListener()
        return true
    }
    
    /* FIREBASE SWIZZLING START */
    // Firebase on swift requires to remove swizzling and we need to do some manual data transfers
    // https://firebase.google.com/docs/ios/learn-more#swiftui
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
        // Further handling of the device token if needed by the app
        // ...
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification notification: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        if Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
            return
        }
        // This notification is not auth related; it should be handled separately.
    }
    
    func application(
        _ application: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any]
    ) -> Bool {
        // Facebook
        if ApplicationDelegate.shared.application(
            application,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        ) {
            return true
        }
        
        if GIDSignIn.sharedInstance.handle(url) {
            return true
        }
                
        if Auth.auth().canHandle(url) {
            return true
        }
        // URL not auth related; it should be handled separately.
        return false
    }
    
    // We are not using UIScene so this is not needed
//    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//      for urlContext in URLContexts {
//          let url = urlContext.url
//          Auth.auth().canHandle(url)
//      }
//      // URL not auth related; it should be handled separately.
//    }
    
    //  Facebook SDK scene config
//    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//        guard let url = URLContexts.first?.url else {
//            return
//        }
//
//        ApplicationDelegate.shared.application(
//            UIApplication.shared,
//            open: url,
//            sourceApplication: nil,
//            annotation: [UIApplication.OpenURLOptionsKey.annotation]
//        )
//    }

    /* FIREBASE SWIZZLING END */
}

@main
struct Cook_LogApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @Injected(\.appConfig) private var appConfig
    @InjectedObject(\.errorService) private var errorService
    @InjectedObject(\.networkService) var networkService
    
    
    func appear() {
        networkService.simulateOnOff()
    }
    
    init() {
        do {
            try appConfig.load()
        } catch let err {
            errorService.error = err
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .onAppear(perform: appear)
        }
    }
}
