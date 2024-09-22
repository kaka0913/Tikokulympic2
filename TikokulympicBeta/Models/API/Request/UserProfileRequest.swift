//
//  UserProfileRequest.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/22.
//

import Foundation
import Alamofire

struct UserProfileResponse: ResponseProtocol {
    let message: String
}

struct UserProfileRequest: RequestProtocol {
    typealias Response = UserProfileResponse
    var method: HTTPMethod { .get }
    var path: String { "/users/\(userId)/profile" }

    let userId: Int
}
