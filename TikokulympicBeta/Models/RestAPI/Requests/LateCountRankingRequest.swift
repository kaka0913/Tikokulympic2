//
//  LateCountRankingRequest.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/11/09.
//

import Foundation
import Alamofire

struct LateCountRankingResponse: ResponseProtocol, Decodable {
    let ranking: [TotalUserRanking]
}

struct LateCountRankingRequest: RequestProtocol {
    typealias Response = LateCountRankingResponse
    var method: HTTPMethod { .get }
    var path: String { "/rankings/count"}
}
