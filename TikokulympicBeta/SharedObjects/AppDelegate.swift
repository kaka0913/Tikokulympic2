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
import GooglePlaces

final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var locationManager: CLLocationManager?
    var backgroundSessionCompletionHandler: (() -> Void)?
    var backgroundUploader: BackgroundLocationUploader!
    var locationTimer: Timer?
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    // 到着通知が送信されたかどうかを保持するプロパティ
    var hasSentArrivalNotification: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "hasSentArrivalNotification")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "hasSentArrivalNotification")
        }
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        // インクリメンタルサーチのためのAPIキーの設定
        if let apiKey = APIKeyManager.shared.apiKey(for: "GMSPlacesClient_API_Key") {
            GMSPlacesClient.provideAPIKey(apiKey)
        } else {
            print("API key not found.")
        }
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

        // 起動時に3時間以内かどうかを確認し、必要なら通信を開始
        if shouldStartLocationUpdates() {
            if !hasSentArrivalNotification {
                startLocationTimer()
            }
            WebSocketClient.shared.connect()
        } else {
            print("start_timeが3時間以内ではないため、WebSocket通信を開始しません。")
        }

        return true
    }

    // MARK: - アプリの状態ハンドラ

    @objc func appDidEnterBackground() {
        // start_timeが3時間以内かどうかを再確認
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

            // 位置情報取得タイマーを開始（到着通知が未送信の場合）
            if !hasSentArrivalNotification && locationTimer == nil {
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
        }

        // 位置情報取得タイマーを開始（到着通知が未送信の場合）
        if shouldStartLocationUpdates() && !hasSentArrivalNotification && locationTimer == nil {
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
            // 位置情報取得タイマーを開始（到着通知が未送信の場合）
            if !hasSentArrivalNotification && locationTimer == nil {
                startLocationTimer()
            }
        }
        // ダイアログの表示が必要かチェック
        if UserDefaults.standard.bool(forKey: "shouldShowAliaseDialog") {
            if let aliase = UserDefaults.standard.string(forKey: "lastAliase"), !hasShownAliaseDialog(for: aliase) {
                showAliaseDialog(aliase: aliase)
            }
        }
    }

    // MARK: - セットアップメソッド

    private func setupDefaultUserInfo() {

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
        if hasSentArrivalNotification {
            // 到着通知が既に送信されている場合はタイマーを開始しない
            return
        }
        locationTimer?.invalidate() // 既存のタイマーがあれば無効化
        locationTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(requestCurrentLocation), userInfo: nil, repeats: true)
        RunLoop.main.add(locationTimer!, forMode: .common)
    }

    // タイマーによって呼び出されるメソッド
    @objc private func requestCurrentLocation() {
        if shouldStartLocationUpdates() && !hasSentArrivalNotification {
            locationManager?.requestLocation()
        } else {
            // 位置情報の取得を停止し、タイマーを無効化
            locationTimer?.invalidate()
            locationTimer = nil
            print("位置情報の取得を停止しました")
        }
    }

    // 位置情報の取得を停止するメソッド
    private func stopLocationUpdates() {
        // タイマーを無効化
        locationTimer?.invalidate()
        locationTimer = nil

        // 位置情報の更新を停止
        locationManager?.stopUpdatingLocation()

        print("位置情報の取得を停止しました")
    }

    // MARK: - バックグラウンドURLセッションのハンドリング

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        // バックグラウンドセッションの処理
        backgroundSessionCompletionHandler = completionHandler
        backgroundUploader = BackgroundLocationUploader.shared
    }

    // MARK: - start_timeから3時間以内かどうかを判定

    func shouldStartLocationUpdates() -> Bool {
        if let savedDateString = UserDefaults.standard.string(forKey: "start_time") {
            let isoFormatter = ISO8601DateFormatter()
            if let savedDate = isoFormatter.date(from: savedDateString) {
                let currentDate = Date()

                // 3時間 = 10800秒
                let threeHoursInSeconds: TimeInterval = 10800

                // 現在の時間がstart_timeの3時間前から3時間後までの範囲にあるかをチェック
                let timeDifference = currentDate.timeIntervalSince(savedDate)

                return timeDifference >= -threeHoursInSeconds && timeDifference <= threeHoursInSeconds
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
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("didRegisterForRemoteNotificationsWithDeviceToken が呼び出されました")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    @objc func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            UserDefaults.standard.set(token, forKey: "fcmToken")
            print("Firebase tokenの保存が完了しました")
            
        } else {
            print("FCM tokenの取得に失敗しました")
        }
    }
}


// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    // 通知がフォアグラウンドで表示される直前に呼ばれる
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // 通知のデータを処理
        let userInfo = notification.request.content.userInfo
        processNotificationData(userInfo: userInfo)
        completionHandler([.banner, .list, .sound])
    }
    
    private func hasShownAliaseDialog(for aliase: String) -> Bool {
        if let lastDisplayedAliase = UserDefaults.standard.string(forKey: "lastDisplayedAliase") {
            return lastDisplayedAliase == aliase
        }
        return false
    }

    // 通知のデータを処理してUserDefaultsに保存するメソッド
    private func processNotificationData(userInfo: [AnyHashable: Any]) {
        guard let content = userInfo["content"] as? String else {
            print("👩‍🚀 'content' キーが通知データに含まれていません")
            return
        }
        
        switch content {
        case "remind":
            handleRemindNotification(userInfo: userInfo)
        case "aliase":
            handleAliaseNotification(userInfo: userInfo)
        case "caution":
            print("cautionの通知を受信しました")
        default:
            print("未知のcontentパターンです: \(content)")
        }
    }

    private func showAliaseDialog(aliase: String) {
        // 最前面のビューコントローラを取得
        if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
            let alertController = UIAlertController(
                title: "遅刻のペナルティ",
                message: "「\(aliase)」の称号が付与されてしまいました。次は気をつけてください！",
                preferredStyle: .alert
            )
            
            // 閉じるボタンを追加
            let closeAction = UIAlertAction(title: "閉じる", style: .default) { _ in
                // ダイアログが表示されたことを記録
                UserDefaults.standard.set(aliase, forKey: "lastDisplayedAliase")
                UserDefaults.standard.set(false, forKey: "shouldShowAliaseDialog")
            }
            alertController.addAction(closeAction)
            
            // ダイアログを表示
            topViewController.present(alertController, animated: true, completion: nil)
        } else {
            print("トップのビューコントローラを取得できませんでした")
        }
    }
    
    private func handleRemindNotification(userInfo: [AnyHashable: Any]) {
        guard let title = userInfo["title"] as? String,
              let location = userInfo["location"] as? String,
              let latitudeValue = userInfo["latitude"],
              let longitudeValue = userInfo["longitude"],
              let eventid = userInfo["event_id"],
              let startTime = userInfo["start_time"] else {
            print("👩‍🚀 通知データの解析に失敗しました。必要なキーが不足している可能性があります")
            return
        }
        
        let latitude: Double
        let longitude: Double
        
        if let lat = latitudeValue as? Double {
            latitude = lat
        } else if let latString = latitudeValue as? String, let lat = Double(latString) {
            latitude = lat
        } else {
            print("👩‍🚀 緯度の値が無効です:", latitudeValue)
            return
        }
        
        if let lon = longitudeValue as? Double {
            longitude = lon
        } else if let lonString = longitudeValue as? String, let lon = Double(lonString) {
            longitude = lon
        } else {
            print("👩‍🚀 経度の値が無効です:", longitudeValue)
            return
        }
        
        // UserDefaultsに保存
        UserDefaults.standard.set(eventid, forKey: "eventid")
        UserDefaults.standard.set(title, forKey: "title")
        UserDefaults.standard.set(location, forKey: "location")
        UserDefaults.standard.set(latitude, forKey: "latitude")
        UserDefaults.standard.set(longitude, forKey: "longitude")
        UserDefaults.standard.set(startTime, forKey: "start_time")
        
        // 到着通知フラグをリセット
        UserDefaults.standard.set(false, forKey: "hasSentArrivalNotification")
        
        // 位置情報更新の再評価と開始
        if shouldStartLocationUpdates() {
            if !hasSentArrivalNotification && locationTimer == nil {
                startLocationTimer()
            }
            // WebSocketの再接続
            if !WebSocketClient.shared.isConnected {
                WebSocketClient.shared.connect()
            }
        } else {
            // 必要に応じて位置情報更新を停止
            stopLocationUpdates()
        }
    }
    
    private func handleAliaseNotification(userInfo: [AnyHashable: Any]) {
        guard let aliase = userInfo["aliase"] as? String else {
            print("👩‍🚀 'aliase' キーが通知データに含まれていません")
            return
        }
        
        let lastAliase = UserDefaults.standard.string(forKey: "lastAliaseNotification")
        
        if lastAliase != aliase {
            showAliaseDialog(aliase: aliase)
            UserDefaults.standard.set(aliase, forKey: "lastAliaseNotification")
        } else {
            print("👩‍🚀 この 'aliase' のダイアログは既に表示されています")
        }
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .compactMap { $0 as? UIWindowScene }
        .first?.windows
        .filter { $0.isKeyWindow }.first?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}


// MARK: - バックグラウンドでの通知受信時の処理

extension AppDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // 通知のデータを処理
        processNotificationData(userInfo: userInfo)
        completionHandler(.newData)
    }
}


// MARK: - CLLocationManagerDelegate

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }

        if !hasSentArrivalNotification {
            // 目的地の緯度経度を取得
            let destLatitude = UserDefaults.standard.double(forKey: "latitude")
            let destLongitude = UserDefaults.standard.double(forKey: "longitude")
            let destLocation = CLLocation(latitude: destLatitude, longitude: destLongitude)

            // 距離を計算（メートル単位）
            let distance = newLocation.distance(from: destLocation)

            if distance <= 500 {
                // 到着通知を送信
                hasSentArrivalNotification = true

                let userid = UserDefaults.standard.integer(forKey: "userid")
                let isoFormatter = ISO8601DateFormatter()
                let formattedArrivalTime = isoFormatter.string(from: Date())

                let messageDict: [String: Any] = [
                    "action": "arrival_notification",
                    "user_id": userid,
                    "arrival_time": formattedArrivalTime
                ]

                if let jsonData = try? JSONSerialization.data(withJSONObject: messageDict),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    WebSocketClient.shared.sendMessage(jsonString) { success in
                        if success {
                            print("Arrival notification sent via WebSocket successfully")
                        } else {
                            print("Failed to send arrival notification via WebSocket")
                        }
                    }
                } else {
                    print("Failed to serialize arrival notification message to JSON")
                }

                // 位置情報の取得と送信を停止
                stopLocationUpdates()
            } else {
                // 通常の位置情報送信処理
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
        let userid = UserDefaults.standard.integer(forKey: "userid")

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
