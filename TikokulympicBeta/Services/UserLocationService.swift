////
////  TikokuRankingViewModel.swift
////  TikokulympicBeta
////
////  Created by 株丹優一郎 on 2024/09/19.
////
//
//import Foundation
//import CoreLocation
//import Supabase
//
//class UserLocationService: NSObject, ObservableObject {
//    // MARK: - プロパティ
//    
//    @Published var currentLocation: CLLocation?
//    @Published var errorMessage: String?
//    
//    private let locationManager = CLLocationManager()
//    private let supabaseClient: SupabaseClient
//    private var realTimeLocationService: RealTimeDataBaseService?
//    
//    // MARK: - イニシャライザ
//    
//    override init() async {
//        self.supabaseClient = SupabaseClientManager.shared.client!
//        super.init()
//        setupLocationManager()
//        await setupRealTimeService()
//    }
//    
//    // MARK: - セットアップメソッド
//    
//    private func setupLocationManager() {
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        checkLocationAuthorization()
//    }
//    
//    private func setupRealTimeService() async {
//        await realTimeLocationService = RealTimeDataBaseService()
//    }
//    
//    // MARK: - 位置情報の開始
//    
//    func startUpdatingLocation() {
//        locationManager.startUpdatingLocation()
//    }
//    
//    // MARK: - 位置情報の停止
//    
//    func stopUpdatingLocation() {
//        locationManager.stopUpdatingLocation()
//    }
//    
//    // MARK: - 位置情報の送信
//    
//    func sendLocationToSupabase(location: CLLocation) async {
////        let userId =
////        let latitude = location.coordinate.latitude
////        let longitude = location.coordinate.longitude
////        let timestamp = ISO8601DateFormatter().string(from: location.timestamp)
//        
//        struct req: Codable {
//            let userid: Int
//            let latitude: Double
//            let longitude: Double
//            var timestamp = ISO8601DateFormatter().string(from: Date())
//        }
//        
//        let values = [
//            req(userid: 22222, latitude: 34.000, longitude: 33.000),
//            req(userid: 333333, latitude: 35.000, longitude: 33.000)
//        ]
//        
//        do {
//            let response = try await supabaseClient
//                .from("locations")
//                .insert(values)
//                .execute()
//            
//            if response.response.statusCode == 200  {
//                print("性行為")
//            }
//            if response.response.statusCode == 500 {
//                print("インターナルサーバーsex")
//            }
//            if response.response.statusCode == 404{
//                print("not manko")
//            }
//        } catch {
//            print("Error sending location to Supabase: \(error.localizedDescription)")
//            DispatchQueue.main.async {
//                self.errorMessage = "位置情報の送信中にエラーが発生しました。"
//            }
//        }
//    }
//}
//
//extension UserLocationService: CLLocationManagerDelegate {
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        checkLocationAuthorization()
//    }
//    
//    private func checkLocationAuthorization() {
//        switch locationManager.authorizationStatus {
//        case .notDetermined:
//            locationManager.requestAlwaysAuthorization()
//        case .restricted, .denied:
//            DispatchQueue.main.async {
//                self.errorMessage = "位置情報の使用が許可されていません。設定を確認してください。"
//            }
//        case .authorizedWhenInUse, .authorizedAlways:
//            locationManager.startUpdatingLocation()
//        @unknown default:
//            break
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        DispatchQueue.main.async {
//            self.currentLocation = location
//        }
//        Task {
//            await sendLocationToSupabase(location: location)
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        DispatchQueue.main.async {
//            self.errorMessage = "位置情報の取得に失敗しました。"
//        }
//    }
//}
//
//extension UserLocationService: RealTimeLocationServiceDelegate {
//    func didReceiveInsertEvent(_ message: RealtimeMessage) {
//        print("INSERT イベントを受信: \(message.event)")
//        // 必要に応じて UI を更新
//    }
//    
//    func didReceiveUpdateEvent(_ message: RealtimeMessage) {
//        print("UPDATE イベントを受信: \(message.event)")
//        // 必要に応じて UI を更新
//    }
//    
//    func didReceiveDeleteEvent(_ message: RealtimeMessage) {
//        print("DELETE イベントを受信: \(message.event)")
//        // 必要に応じて UI を更新
//    }
//    
//    func didSubscribe(success: Bool, error: Error?) {
//        DispatchQueue.main.async {
//            if success {
//                print("リアルタイムチャネルへの購読に成功しました。")
//            } else {
//                self.errorMessage = "リアルタイムチャネルへの購読に失敗しました。"
//                print("リアルタイムチャネルへの購読に失敗しました: \(error?.localizedDescription ?? "不明なエラー")")
//            }
//        }
//    }
//}
//
//protocol RealTimeLocationServiceDelegate: AnyObject {
//    func didReceiveInsertEvent(_ message: RealtimeMessage)
//    func didReceiveUpdateEvent(_ message: RealtimeMessage)
//    func didReceiveDeleteEvent(_ message: RealtimeMessage)
//    func didSubscribe(success: Bool, error: Error?)
//}
