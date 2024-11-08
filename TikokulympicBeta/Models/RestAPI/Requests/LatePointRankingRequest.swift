//
//  LatePointRequest.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/11/09.
//

import Foundation
import Alamofire

struct LatePointRankingResponse: ResponseProtocol, Decodable {
    let ranking: [LatePointRankingData]
}

struct LatePointRankingRequest: RequestProtocol {
    typealias Response = LatePointRankingResponse
    var method: HTTPMethod { .get }
    var path: String { "/rankings/point"}
}

struct LatePointRankingData: Decodable, Identifiable, RankingParticipant {
    let id: Int
    let position: Int
    let name: String
    let alias: String
    let point: Int
}
