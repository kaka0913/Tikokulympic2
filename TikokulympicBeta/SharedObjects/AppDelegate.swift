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
    var backgroundSessionCompletionHandler: (() -> Void)?
    var backgroundUploader: BackgroundLocationUploader!
    var locationTimer: Timer?
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
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
        backgroundUploader = BackgroundLocationUploader.shared

        // アプリの状態変化を監視
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )

        // 起動時に12時間以内かどうかを確認し、必要なら通信を開始
        if shouldStartLocationUpdates() {
            startLocationTimer()
            WebSocketClient.shared.connect()
        } else {
            print("start_timeが12時間以内ではないため、WebSocket通信を開始しません。")
        }

        return true
    }

    // MARK: - アプリの状態ハンドラ

    @objc func appDidEnterBackground() {
        // start_timeが12時間以内かどうかを再確認
        if shouldStartLocationUpdates() {
            // バックグラウンドでアプリを実行するためのタスクを開始
            backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "LocationUpdate") {
                // タスクが終了しない場合に実行されるハンドラ
                UIApplication.shared.endBackgroundTask(self.backgroundTask)
                self.backgroundTask = .invalid
            }

            // WebSocket通信を開始
            if !WebSocketClient.shared.isConnected {
                WebSocketClient.shared.connect()
            }

            // 位置情報取得タイマーを開始
            if locationTimer == nil {
                startLocationTimer()
            }
        }
    }

    @objc func appWillEnterForeground() {
        // バックグラウンドタスクを終了
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }

        // WebSocketが接続されていなければ再接続
        if shouldStartLocationUpdates() && !WebSocketClient.shared.isConnected {
            WebSocketClient.shared.connect()
            startLocationTimer()
        }
    }
    
    @objc func appDidBecomeActive() {
        // フォアグラウンドになったときの処理
        if shouldStartLocationUpdates() {
            // WebSocketが接続されていなければ接続
            if !WebSocketClient.shared.isConnected {
                WebSocketClient.shared.connect()
            }
            // 位置情報取得タイマーが動作していなければ開始
            if locationTimer == nil {
                startLocationTimer()
            }
        }
    }

    // MARK: - セットアップメソッド

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
            WebSocketClient.shared.disconnect()
        }
    }

    // MARK: - バックグラウンドURLセッションのハンドリング

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        // バックグラウンドセッションの処理
        backgroundSessionCompletionHandler = completionHandler
        backgroundUploader = BackgroundLocationUploader.shared
    }

    // MARK: - start_timeから12時間以内かどうかを判定

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
                return timeInterval <= 43200 && timeInterval >= 0 // 12時間以内
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

    // MARK: - ensureStartTimeIsSet メソッドの追加
    private func ensureStartTimeIsSet() {
        if UserDefaults.standard.string(forKey: "start_time") == nil {
            print("start_timeは現在未設定です")

        } else {
            print("start_timeは既に設定されています。")
            //TODO: 既にstart_timeが設定されている場合の処理を追加
        }
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

        // バックグラウンドタスクを開始
        var taskID: UIBackgroundTaskIdentifier = .invalid
        taskID = UIApplication.shared.beginBackgroundTask(withName: "SendLocation") {
            // 時間切れの場合
            UIApplication.shared.endBackgroundTask(taskID)
            taskID = .invalid
        }

        // 位置情報を送信
        BackgroundLocationUploader.shared.sendLocation(newLocation) {
            // バックグラウンドタスクを終了
            UIApplication.shared.endBackgroundTask(taskID)
            taskID = .invalid
        }
    }

    // 位置情報の取得に失敗した場合
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置情報の取得に失敗しました: \(error)")
    }
}


// MARK: - URLSessionDelegate

extension AppDelegate: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        // 複数イベントが同日にあることを想定して、start_timeの確認と設定を行う
        ensureStartTimeIsSet()

        // バックグラウンドタスクの完了ハンドラを呼び出す
        if let completionHandler = backgroundSessionCompletionHandler {
            backgroundSessionCompletionHandler = nil
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
}


// MARK: - バックグラウンド通信

class BackgroundLocationUploader {
    // シングルトンインスタンス
    static let shared = BackgroundLocationUploader()

    // プライベートイニシャライザ
    private init() { }

    func sendLocation(_ location: CLLocation, completion: @escaping () -> Void) {
        let userid = UserDefaults.standard.string(forKey: "userid") ?? "unknown_user"

        let messageDict: [String: Any] = [
            "action": "update_location",
            "user_id": userid,
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude
        ]

        if let jsonData = try? JSONSerialization.data(withJSONObject: messageDict),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            WebSocketClient.shared.sendMessage(jsonString) { success in
                if success {
                    print("BackgroundLocationUploader: WebSocketで位置情報を送信しました")
                } else {
                    print("BackgroundLocationUploader: WebSocketでの位置情報送信に失敗しました")
                }
                completion()
            }
        } else {
            print("BackgroundLocationUploader: JSONシリアライズに失敗しました")
            completion()
        }
    }
}
