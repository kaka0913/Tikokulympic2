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
            UserRankingData(id: 1,  position: 1, name: "しゅうと", alias: "遅刻王", distance: 0),
            UserRankingData(id: 51, position: 2, name: "ゆうた", alias: "ねぼう王", distance: 0),
            UserRankingData(id: 21, position: 3, name: "しょうま", alias: "ねぼう王", distance: 0),
            UserRankingData(id: 31, position: 4, name: "かぶたん", alias: "遅刻王", distance: 0),
            UserRankingData(id: 61, position: 5, name: "ゆいぴ", alias: "しらふ酔王", distance: 0)
        ]
    }
}
