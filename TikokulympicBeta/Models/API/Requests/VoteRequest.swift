//
//  VoteRequest.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/10/18.
//

import Foundation
import Alamofire

struct VoteResponse: ResponseProtocol {
    let isSuccess: Bool
    
    private enum CodingKeys: String, CodingKey {
        case isSuccess = "is_success"
    }
}

struct VoteRequest: RequestProtocol {
    typealias Response = VoteResponse
    var method: HTTPMethod { .post }
    var path: String { "/events/\(eventid)/votes" }
    let eventid: Int
    let option: String
    
    var parameters: Parameters? {
        return [
            "user_id": UserDefaults.standard.integer(forKey: "userid"),
            "option": option
        ]
    }
}
