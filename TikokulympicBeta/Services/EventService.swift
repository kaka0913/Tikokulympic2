//
//  EventService.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/10/18.
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
            is_all_day: event.isAllDay ?? false,
            start_time: startTime,
            end_time: endTime,
            closing_time: closingTime,
            location_name: event.locationName,
            cost: Int(event.cost),
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
            print("イベント取得に成功しました")
            return response
        } catch {
            print("イベント取得に失敗しました: \(error)")
            throw error
        }
    }
    
    func putVote(eventid: Int, option: String) async {
        let userid = UserDefaults.standard.integer(forKey: "userid")
        let voteRequest = VoteRequest(eventid: eventid, userid: String(userid), option: option)
        
        do {
            let response: VoteResponse = try await APIClient.shared.call(request: voteRequest)
            if response.isSuccess {
                print("投票に成功しました")
            } else {
                print("投票に失敗しました")
            }
        } catch {
            print("投票中にエラーが発生しました: \(error)")
        }
    }
}
