//
//  ArrivalRanking.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/10/23.
//

import Foundation

struct ArrivalUserData: Decodable, Identifiable {
    let id: Int
    let position: Int
    let name: String
    let alias: String?
    let arrivalTime: Int
}
