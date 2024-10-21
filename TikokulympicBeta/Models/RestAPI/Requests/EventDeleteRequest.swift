//
//  DeleteEventRequest.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/10/20.
//

import Foundation
import Alamofire

struct EventDeleteResponse: ResponseProtocol {
    let isSuccess: Bool
}

struct EventDeleteRequest: RequestProtocol {
    typealias Response = EventDeleteResponse
    let eventid: Int
    var method: HTTPMethod { .delete }
    var path: String { "/events/\(eventid)" }
}
