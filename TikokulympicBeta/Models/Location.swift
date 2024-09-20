//
//  LocationModel.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/20.
//

import Foundation

struct Location: Codable {
    let id: Int
    let user_id: Int
    let latitude: Float
    let longitude: Float
}

struct LocatinInfo: Codable {
    let latitude: Double
    let longitude: Double
    var createAt = Date()
}
