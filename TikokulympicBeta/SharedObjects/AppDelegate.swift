//
//  AppDelegate.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/20.
//

import CoreLocation
import Firebase
import FirebaseCore
import FirebaseMessaging
import Foundation
import GoogleSignIn
import SwiftUI
import UserNotifications
import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var locationManager: CLLocationManager?
    var backgroundSessionCompletionHandler: (() -> Void)? // TODO: バックグラウンド処理が完了したら呼び出される処理
    var backgroundUploader: BackgroundLocationUploader!
    var locationTimer: Timer?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self

        // デフォルトのユーザー情報を設定
        setupDefaultUserInfo()

        // 通知の許可をリクエスト
        requestNotificationAuthorization()

        // 位置情報マネージャのセットアップ
        setupLocationManager()

        // バックグラウンドアップローダーの初期化
        backgroundUploader = BackgroundLocationUploader(delegate: self)

        // 10秒ごとに位置情報を取得するタイマーを開始
        startLocationTimer()

        return true
    }

    // MARK: - Setup Methods
    private func setupDefaultUserInfo() {
        UserDefaults.standard.set(51, forKey: "userid") // TODO: 開発中はデフォルトのuseridを入れておく
        
        // TODO: 通知できるまではデフォルトの値を入れておく
        let title = "ハッカソン"
        let location = "立命館大学OIC"
        let latitude: Double = 34.8103
        let longitude: Double = 135.5610

        // TODO: 時間はいったん現在の1時間後に設定
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current // 必要に応じて設定

        let startTimeDate = Date().addingTimeInterval(3600) // 1時間後
        let startTime = dateFormatter.string(from: startTimeDate)

        UserDefaults.standard.set(latitude, forKey: "latitude")
        UserDefaults.standard.set(longitude, forKey: "longitude")
        UserDefaults.standard.set(startTime, forKey: "start_time")
        UserDefaults.standard.set(title, forKey: "title")
        UserDefaults.standard.set(location, forKey: "location")
    }

    private func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
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
    }

    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false

        // 位置情報の使用許可をリクエスト
        locationManager?.requestAlwaysAuthorization()
    }

    // 10秒ごとに位置情報を取得するタイマーを開始
    private func startLocationTimer() {
        locationTimer?.invalidate() // 既存のタイマーがあれば無効化
        locationTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(requestCurrentLocation), userInfo: nil, repeats: true)
        RunLoop.main.add(locationTimer!, forMode: .common)
    }

    // タイマーによって呼び出されるメソッド
    @objc private func requestCurrentLocation() {
        if shouldStartLocationUpdates() {
            locationManager?.requestLocation()
        } else {
            // 位置情報の取得を停止し、タイマーを無効化
            locationTimer?.invalidate()
            locationTimer = nil
            print("位置情報の取得を停止しました")
        }
    }

    // MARK: - Background URL Session Handling
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        // バックグラウンドセッションの処理
        backgroundSessionCompletionHandler = completionHandler
        backgroundUploader = BackgroundLocationUploader(delegate: self)
    }

    // MARK: - start_timeから1日以内かどうかを判定
    func shouldStartLocationUpdates() -> Bool {
        if let savedDateString = UserDefaults.standard.string(forKey: "start_time") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone.current // 必要に応じて設定

            if let savedDate = dateFormatter.date(from: savedDateString) {
                let currentDate = Date()
                let timeInterval = savedDate.timeIntervalSince(currentDate)
                print("savedDate: \(savedDate), currentDate: \(currentDate), timeInterval: \(timeInterval)")
                return timeInterval <= 86400 && timeInterval >= 0 // 1日以内
            } else {
                print("日付のパースに失敗しました")
            }
        } else {
            print("start_timeが設定されていません")
        }
        return false
    }

    // MARK: - Remote Notification Failure Handling
    func application(
        _ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to register for remote notifications with error \(error)")
    }
}


// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            UserDefaults.standard.set(token, forKey: "fcmToken")
        } else {
            print("FCM tokenの取得に失敗しました")
        }
    }
}


// MARK: - UNUserNotificationCenterDelegate

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


// MARK: - CLLocationManagerDelegate

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }

        let latitude = newLocation.coordinate.latitude
        let longitude = newLocation.coordinate.longitude
        print("現在の位置情報: 緯度 \(latitude), 経度 \(longitude)")

        // 必要であれば、ここで位置情報を送信する処理を追加
        // backgroundUploader.sendLocation(newLocation)
    }

    // 位置情報の取得に失敗した場合
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置情報の取得に失敗しました: \(error)")
    }
}

// MARK: - URLSessionDelegate

extension AppDelegate: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        if let completionHandler = backgroundSessionCompletionHandler {
            backgroundSessionCompletionHandler = nil
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
}


// MARK: - 実装は別の箇所で行なってかつ中身も変更する予定
//TODO: websocketの実装が必要

class BackgroundLocationUploader {
    private var session: URLSession!

    init(delegate: URLSessionDelegate) {
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.yourapp.background")
        configuration.sessionSendsLaunchEvents = true
        configuration.isDiscretionary = false
        session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
    }

    func sendLocation(_ location: CLLocation) {
        var request = URLRequest(url: URL(string: "https://your-server.com/upload")!)
        request.httpMethod = "POST"
        let body: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "timestamp": location.timestamp.timeIntervalSince1970
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.uploadTask(with: request, from: request.httpBody!)
        task.resume()
    }
}
