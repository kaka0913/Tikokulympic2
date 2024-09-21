//
//  ArrivalRequest.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/17.
//

import Alamofire
import Foundation

struct ArrivalResponse: ResponseProtocol {
    let message: String
}

struct ArrivalRequest: RequestProtocol {
    typealias Response = ArrivalResponse
    var method: HTTPMethod { .post }
    var path: String { "/attendances/\(eventId)/\(userId)" }
    var parameters: Parameters? {
        return [
            "is_arrival": isArrival,
            "arrival_time": arrivalTime,
        ]
    }

    let eventId: String
    let userId: String
    let isArrival: Bool
    let arrivalTime: Date
}
