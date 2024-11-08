//
//  TotalRanking.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/11/09.
//

import Foundation

struct TotalUserRanking: Decodable, Identifiable {
    let id: Int
    let position: Int
    let name: String
    let alias: String
    let time: Int
}
