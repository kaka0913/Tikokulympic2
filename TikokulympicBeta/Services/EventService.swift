//
//  EventService.swift
//  TikokulympicBeta
//
//  Created by 澤木柊斗 on 2024/09/26.
//

import Foundation


class EventService {
    private let apiClient = APIClient.shared
    static let shared = EventService()

    func postNewEvent(event: Event) async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let startTime = dateFormatter.string(from: event.startDateTime)
        let endTime = dateFormatter.string(from: event.endDateTime)
        let closingTime = dateFormatter.string(from: event.closingDateTime)

        let request = EventEditingRequest(
            title: event.title,
            description: event.description,
            is_all_day: event.isAllDay,
            start_time: startTime,
            end_time: endTime,
            closing_time: closingTime,
            location_name: event.locationName,
            cost: Int(event.cost) ?? 0,
            message: event.message,
            author_id: event.author?.authorId ?? 0,
            latitude: "\(event.latitude)",
            longitude:"\(event.longitude)"
        )
        
        do {
            let response = try await apiClient.call(request: request)
            print("イベント作成に成功しました: \(response)")
        } catch {
            print("イベント作成に失敗しました: \(error)")
        }
    }
      func fetchEvents() async throws -> EventsResponse {
        let request = EventsRequest()

        do {
            let response = try await apiClient.call(request: request)
            return response
        } catch {
            throw error
        }
    }
}
