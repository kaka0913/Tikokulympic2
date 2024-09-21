//
//  SignupRequsest.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/20.
//

import Alamofire
import Foundation

struct SignupResponse: ResponseProtocol {
    let id: Int
}

struct SignupRequest: RequestProtocol {
    typealias Response = SignupResponse
    var method: HTTPMethod { .post }
    var path: String { "/signup" }
    let token: String
    let user_name: String
    let auth_id: Int

    var parameters: Parameters? {
        return [
            "token": token,
            "user_name": user_name,
            "auth_id": auth_id,
        ]
    }
}
