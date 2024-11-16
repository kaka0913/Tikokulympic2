import Firebase
import FirebaseCore
import FirebaseMessaging
import GoogleSignIn
import SwiftUI
import UserNotifications
import GooglePlaces

@main
struct TikokulympicBetaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("userid") var userid: Int?
    let auth = SupabaseService.shared.auth

    var body: some Scene {
        WindowGroup {
            if userid != nil {
                ContentView()
                    .onOpenURL { url in
                        GIDSignIn.sharedInstance.handle(url)
                        auth.handle(url)
                    }
            } else {
                AuthView()
            }
        }
    }
}
