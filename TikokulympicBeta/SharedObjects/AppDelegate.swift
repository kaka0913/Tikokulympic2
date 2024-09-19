//
//  AppDelegate.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/20.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseMessaging
import GoogleSignIn
import SwiftUI
import UserNotifications
import CoreLocation

final class AppDelegate: UIResponder, UIApplicationDelegate {
    var locationManager: CLLocationManager?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        // 通知の許可をリクエスト
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if let error = error {
                print("通知の許可リクエストでエラーが発生しました: \(error)")
                return
            }
            if granted {
                DispatchQueue.main.async {
                    print("通知の許可が得られました")
                    UIApplication.shared.registerForRemoteNotifications()
                    print("UIApplication.shared.registerForRemoteNotifications()が呼ばれました")
                }
            } else {
                print("通知の許可が得られませんでした")
            }
        }
        UNUserNotificationCenter.current().delegate = self
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        locationManager?.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.distanceFilter = 10
            locationManager?.activityType = .fitness
            locationManager?.startUpdatingLocation()
        }

        return true
    }

    func application(
        _ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to register for remote notifications with error \(error)")
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase token: \(String(describing: fcmToken))")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .list, .sound])
    }

    // ユーザーが通知をタップしたとき、またはカスタムアクションを実行したときに呼び出される
    // 通知に含まれる情報を取り出し、アプリ内で適切な処理を行うために他の部分に伝達する
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // アプリ内の他の部分に対して、通知を受信したことを知らせる
        let userInfo = response.notification.request.content.userInfo
        NotificationCenter.default.post(
            name: Notification.Name("didReceiveRemoteNotification"),
            object: nil,
            userInfo: userInfo
        )
        completionHandler()
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        
        let location = CLLocationCoordinate2D(
            latitude: newLocation.coordinate.latitude,
            longitude: newLocation.coordinate.longitude
        )
        
        print("緯度: \(location.latitude), 経度: \(location.longitude)")
    }
}
