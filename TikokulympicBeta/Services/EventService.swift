//
//  EventService.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/10/07.
//

import Foundation

class EventService {
    private let apiClient = APIClient.shared
    static let shared = EventService()

    func postNewEvent(event: Event) async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let startTime = dateFormatter.string(from: event.startTime)
        let endTime = dateFormatter.string(from: event.endTime)
        let closingTime = dateFormatter.string(from: event.closingTime)
        
        let request = EventEditingRequest(
            title: event.title,
            description: event.description,
            is_all_day: event.isAllDay,
            start_time: startTime,
            end_time: endTime,
            closing_time: closingTime,
            location_name: event.locationName,
            cost: event.cost,
            message: event.message,
            author_id: event.managerId,
            latitude: event.latitude,
            longitude: event.longitude
        )
        
        do {
            let response = try await apiClient.call(request: request)
            print("イベント作成に成功しました: \(response)")
        } catch {
            print("イベント作成に失敗しました: \(error)")
        }
    }
}
