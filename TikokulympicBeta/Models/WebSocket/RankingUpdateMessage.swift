//
//  RankingUpdateMessage.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/10/15.
//

import Foundation

struct RankingUpdateMessage: Decodable {
    let action: String
    let ranking: [UserRankingData]
}
