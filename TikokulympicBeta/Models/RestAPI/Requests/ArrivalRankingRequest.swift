//
//  ArrivalRankingRequest.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/10/23.
//

import Foundation
import Alamofire

struct ArrivalRankingResponse: ResponseProtocol {
    let arrivalRankings: [ArrivalUserData]
}

struct ArrivalRankingRequest: RequestProtocol {
    typealias Response = ArrivalRankingResponse
    var method: HTTPMethod { .get }
    var path: String { "/events/\(eventid)/arrival_ranking" }
    let eventid: Int
}
