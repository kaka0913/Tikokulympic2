//
//  CreateEventReqiest.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/10/07.
//

import Foundation
import Alamofire

struct EventEditingResponse: ResponseProtocol {
    let event_id: Int
    let message: String
    
    private enum CodingKeys: String, CodingKey {
        case event_id = "eventId"
        case message
    }
}

struct EventEditingRequest: RequestProtocol {
    typealias Response = EventEditingResponse
    var method: HTTPMethod { .post }
    var path: String { "/events" }

    let title: String
    let description: String
    let is_all_day: Bool
    let start_time: String
    let end_time: String
    let closing_time: String
    let location_name: String
    let cost: Int
    let message: String
    let author_id: Int
    let latitude: String
    let longitude: String


    var parameters: Parameters? {
        return [
            "title": title,
            "description": description,
            "is_all_day": is_all_day,
            "start_time": start_time,
            "end_time": end_time,
            "closing_time": closing_time,
            "location_name": location_name,
            "cost": cost,
            "message": message,
            "author_id": author_id,
            "latitude": latitude,
            "longitude": longitude
        ]
    }
}
