import Firebase
import FirebaseCore
import FirebaseMessaging
import GoogleSignIn
import SwiftUI
import UserNotifications

@main
struct TikokulympicBetaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("userid") var userid: Int?

    var body: some Scene {
        WindowGroup {
            if userid != nil {
                ContentView()
                    .onOpenURL { url in
                        GIDSignIn.sharedInstance.handle(url)
                    }
            } else {
                AuthView()
            }
        }
    }
}
