//
//  TikokuRankingViewModel.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/20.
//

import CoreLocation
import UIKit
import SwiftUI

class TikokuRankingViewModel: ObservableObject {
    @Published var userRankings: [UserRankingData] = []
    @AppStorage("latitude") var latitude: Double = 0.0
    @AppStorage("longitude") var longitude: Double = 0.0
   
    private let locationManager = CLLocationManager()
    private var destinationLocation: CLLocation?
    
    init() {
        destinationLocation = CLLocation(latitude: latitude, longitude: longitude)
        setupLocationManager()
        setupMockData()
    }
    
    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupMockData() {
        userRankings = [
            UserRankingData(id:1,  name: "しゅうと", title: "遅刻王", distance: 0, currentLocation: CLLocation(latitude: 35.6895, longitude: 139.6917), rank: 1),
            UserRankingData(id:51, name: "ゆうた", title: "ねぼう王", distance: 0, currentLocation: CLLocation(latitude: 35.0116, longitude: 135.7681), rank: 2),
            UserRankingData(id:51, name: "しょうま", title: "ねぼう王", distance: 0, currentLocation: CLLocation(latitude: 34.6851, longitude: 135.8050), rank: 3),
            UserRankingData(id: 51, name: "かぶたん", title: "遅刻王", distance: 0, currentLocation: CLLocation(latitude: 34.6937, longitude: 135.5023), rank: 4),
            UserRankingData(id:51, name: "ゆいぴ", title: "しらふ酔王", distance: 0, currentLocation: CLLocation(latitude: 34.6937, longitude: 135.5023), rank: 5),
        ]
        updateDistances()
    }
    
    func updateDistances() {
        for i in 0..<userRankings.count {
            userRankings[i].distance = userRankings[i].currentLocation.distance(from: destinationLocation!) / 1000
        }
    }
}
