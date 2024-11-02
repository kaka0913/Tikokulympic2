//
//  SigninRequest.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/11/02.
//

import Foundation
import Alamofire

struct SigninResponse: ResponseProtocol {
    let id: Int
}

struct SigninRequest: RequestProtocol {
    typealias Response = SigninResponse
    var method: HTTPMethod { .post }
    var path: String { "/auth/signin" }
    let id: String

    var parameters: Parameters? {
        return [
            "auth_id": id,
        ]
    }
}
