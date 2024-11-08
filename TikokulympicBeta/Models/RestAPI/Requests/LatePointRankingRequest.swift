//
//  LatePointRequest.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/11/09.
//

import Foundation
import Alamofire

struct LatePointRankingResponse: ResponseProtocol, Decodable {
    let ranking: [TotalUserRanking]
}

struct LatePointRankingRequest: RequestProtocol {
    typealias Response = LatePointRankingResponse
    var method: HTTPMethod { .get }
    var path: String { "/rankings/point"}
}
