//
//  TimeRankingRequest.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/11/09.
//

import Foundation
import Alamofire

struct LateTimeRankingResponse: ResponseProtocol, Decodable {
    let ranking: [LateTimeRankingData]
}

struct LateTimeRankingRequest: RequestProtocol {
    typealias Response = LateTimeRankingResponse
    var method: HTTPMethod { .get }
    var path: String { "/rankings/time" }
}

struct LateTimeRankingData: Decodable, Identifiable, RankingParticipant {
    let id: Int
    let position: Int
    let name: String
    let alias: String
    let time: Int
}
