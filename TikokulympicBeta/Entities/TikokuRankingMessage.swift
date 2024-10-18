//
//  TikokurankingMessage.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/10/17.
//

import Foundation

enum TikokuRankingMessage {
    case rankingUpdate([UserRankingData])
    case tikokulympicFinished(String)
}
