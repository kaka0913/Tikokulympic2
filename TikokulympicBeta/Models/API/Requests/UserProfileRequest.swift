//
//  UserProfileRequest.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/22.
//

import Foundation
import Alamofire

struct UserProfileResponse: ResponseProtocol {
    let name: String
    let alias: String?
    let lateCount: Int
    let totalLateTime: Int
    let latePercentage: Float
    let onTimeCount: Int
}

struct UserProfileRequest: RequestProtocol {
    typealias Response = UserProfileResponse
    var method: HTTPMethod { .get }
    var path: String { "/users/\(userid)/profile" }

    let userid: Int
}
