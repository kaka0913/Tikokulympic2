//
//  EventsRequest.swift
//  TikokulympicBeta
//
//  Created by 澤木柊斗 on 2024/09/26.
//

import Foundation
import Alamofire


struct EventsResponse: ResponseProtocol {
    let events: [Event]
}

struct EventsRequest: RequestProtocol {
    typealias Response = EventsResponse
    var method: HTTPMethod { .get }
    var path: String { "/events/board" }
}


