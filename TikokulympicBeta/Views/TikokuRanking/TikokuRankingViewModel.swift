//
//  TikokuRankingViewModel.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/20.
//

import CoreLocation
import UIKit

class TikokuRankingViewModel: ObservableObject {
    @Published var userRankings: [UserRankingData] = []
    @Published var eventName: String = "イベント名"
    @Published var meetingTime: Date = Date()
    @Published var meetingLocation: String = "立命館大学"
    
    private var timer: Timer?
    private let locationManager = CLLocationManager()
    private let destinationLocation = CLLocation(latitude: 34.6937, longitude: 135.5023)//TODO: 取得
    
    init() {
        setupLocationManager()
        setupMockData()
    }
    
    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupMockData() {
        userRankings = [
            UserRankingData(name: "しゅうと", title: "遅刻王", distance: 0, currentLocation: CLLocation(latitude: 35.6895, longitude: 139.6917), rank: 1),
            UserRankingData(name: "ゆうた", title: "ねぼう王", distance: 0, currentLocation: CLLocation(latitude: 35.0116, longitude: 135.7681), rank: 2),
            UserRankingData(name: "しょうま", title: "ねぼう王", distance: 0, currentLocation: CLLocation(latitude: 34.6851, longitude: 135.8050), rank: 3),
            UserRankingData(name: "かぶたん", title: "遅刻王", distance: 0, currentLocation: CLLocation(latitude: 34.6937, longitude: 135.5023), rank: 4),
            UserRankingData(name: "ゆいぴ", title: "しらふ酔王", distance: 0, currentLocation: CLLocation(latitude: 34.6937, longitude: 135.5023), rank: 5),
        ]
        updateDistances()
    }
    
    func updateDistances() {
        for i in 0..<userRankings.count {
            userRankings[i].distance = userRankings[i].currentLocation.distance(from: destinationLocation) / 1000
        }
    }
}
