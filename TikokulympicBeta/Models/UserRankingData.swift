//
//  UserRankingData.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/25.
//

import Foundation
import CoreLocation

struct UserRankingData: Identifiable {
    let id: Int
    let name: String
    let title: String
    var distance: Double
    let currentLocation: CLLocation
    let rank: Int
}
