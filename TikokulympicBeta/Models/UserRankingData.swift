//
//  UserRankingData.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/25.
//

import Foundation
import CoreLocation

struct UserRankingData: Identifiable, Decodable {
    let id: Int
    let position: Int
    let name: String
    let alias: String
    let distance: Float
}
