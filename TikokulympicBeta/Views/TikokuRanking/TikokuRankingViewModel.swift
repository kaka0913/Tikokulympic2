//
//  TikokuRankingViewModel.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/20.
//

import CoreLocation
import UIKit

class TikokuRankingViewModel {
    var locationData: [LocatinInfo] = []

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let latitude = location?.coordinate.latitude ?? 0.0
        let longitude = location?.coordinate.longitude ?? 0.0
        locationData.append(LocatinInfo(latitude: latitude, longitude: longitude))
    }
}
