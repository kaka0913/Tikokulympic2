//
//  TimeRankingRequest.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/11/09.
//

import Foundation
import Alamofire

struct LateTimeRankingResponse: ResponseProtocol, Decodable {
    let ranking: [TotalUserRanking]
}

struct LateTimeRankingRequest: RequestProtocol {
    typealias Response = LateTimeRankingResponse
    var method: HTTPMethod { .get }
    var path: String { "/rankings/time" }
}
