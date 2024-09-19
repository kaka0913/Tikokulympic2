import Firebase
import FirebaseCore
import FirebaseMessaging
import GoogleSignIn
import SwiftUI
import UserNotifications

@main
struct TikokulympicBetaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
