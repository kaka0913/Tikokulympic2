import CoreLocation
import Foundation
import SwiftUI

let userCards: [RankingUserCard] = [
    RankingUserCard(
        name: "しゅうと", title: "遅刻王", distance: "",
        currentLocation: CLLocation(latitude: 35.6895, longitude: 139.6917), rankState: .normal),
    RankingUserCard(
        name: "かぶたん", title: "遅刻王", distance: "",
        currentLocation: CLLocation(latitude: 34.6937, longitude: 135.5023), rankState: .normal),
    RankingUserCard(
        name: "ゆうた", title: "ねぼう王", distance: "",
        currentLocation: CLLocation(latitude: 35.0116, longitude: 135.7681), rankState: .normal),
    RankingUserCard(
        name: "しょうま", title: "ねぼう王", distance: "",
        currentLocation: CLLocation(latitude: 34.6851, longitude: 135.8050), rankState: .normal),
]
// LocationManagerを追加して現在地の取得
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation? = nil

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 10
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.currentLocation = location
        }
    }
}

struct RankingUserCard: View, Identifiable {
    let id = UUID().uuidString
    let name: String
    let title: String
    var distance: String
    let currentLocation: CLLocation?
    var rankState: Rank

    init(
        name: String, title: String, distance: String, currentLocation: CLLocation?, rankState: Rank
    ) {
        self.name = name
        self.title = title
        self.rankState = rankState
        self.currentLocation = currentLocation
        self.distance = distance

        // 大阪の緯度・経度
        let latOsaka = 34.6937
        let lonOsaka = 135.5023

        // 現在地の緯度・経度を取得
        let latCurrentLocation = currentLocation?.coordinate.latitude ?? 35.6895
        let lonCurrentLocation = currentLocation?.coordinate.longitude ?? 139.6917

        // 距離を計算
        let distanceInMeters = RankingUserCard.distanceBetweenLocations(
            lat1: latCurrentLocation, lon1: lonCurrentLocation, lat2: latOsaka, lon2: lonOsaka)
        let distanceInKilometers = distanceInMeters / 1000

        // 距離を文字列に変換して初期化
        self.distance = String(format: "%.2f", distanceInKilometers)
    }

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(width: 377, height: 78)
                .foregroundColor(.lightgray)
                .cornerRadius(15)
                .padding(.top)
                .padding(.leading, 8)
            Rectangle()
                .frame(width: 150, height: 78)
                .foregroundColor(Color.longDistance)
                .clipShape(RoundedCornerShape(corners: [.topLeft, .bottomLeft], radius: 15))
                .padding(.top)
                .padding(.leading, 8)

            HStack(spacing: 0) {
                ZStack {
                    switch rankState {
                    case .first:
                        Image("Explosion")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .padding(.top)
                        Text("1st")
                            .padding(.top)
                            .fontWeight(.bold)
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                    case .secound:
                        Image("RedBomb")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .padding(.top)
                        Text("2nd")
                            .padding(.top, 28)
                            .padding(.trailing, 4)
                            .fontWeight(.bold)
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                    case .third:
                        Image("BlackBomb")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .padding(.top)
                        Text("3rd")
                            .padding(.top, 28)
                            .padding(.trailing, 4)
                            .fontWeight(.bold)
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                    case .normal:
                        Text("4th")
                            .padding(.top, 28)
                            .padding(.leading, 10)
                            .padding(.trailing, 20)
                            .fontWeight(.bold)
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                    }
                }
                .padding(.leading, 10)
                Image("Icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 58, height: 58, alignment: .leading)
                    .padding(.top)
                    .padding(.leading, 5)
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.headline)
                        .padding(.leading, 5)
                        .padding(.bottom, 3)
                        .lineLimit(1)
                    Text(title)
                        .font(.headline)
                        .padding(.leading, 5)
                }
                .padding(.top)
                Spacer()
                Text("\(distance)km")
                    .font(.system(size: 20))
                    .padding(.top, 60)
                    .padding(.trailing, 30)
            }
        }
    }

    // 緯度・経度を引数にして距離を計算する関数
    static func distanceBetweenLocations(lat1: Double, lon1: Double, lat2: Double, lon2: Double)
        -> Double
    {
        let location1 = CLLocation(latitude: lat1, longitude: lon1)
        let location2 = CLLocation(latitude: lat2, longitude: lon2)
        let distance = location1.distance(from: location2)

        return distance
    }
}

#Preview {
    RankingUserCard(
        name: "うううう", title: "ううう", distance: "",
        currentLocation: CLLocation(latitude: 1, longitude: 1), rankState: .normal)
}
