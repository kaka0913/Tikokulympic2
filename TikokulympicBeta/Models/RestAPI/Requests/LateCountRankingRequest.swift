//
//  LateCountRankingRequest.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/11/09.
//

import Foundation
import Alamofire

struct LateCountRankingResponse: ResponseProtocol, Decodable {
    let ranking: [LateCountRankingData]
}

struct LateCountRankingRequest: RequestProtocol {
    typealias Response = LateCountRankingResponse
    var method: HTTPMethod { .get }
    var path: String { "/rankings/count"}
}

struct LateCountRankingData: Decodable, Identifiable, RankingParticipant {
    let id: Int
    let position: Int
    let name: String
    let alias: String
    let count: Int
}
