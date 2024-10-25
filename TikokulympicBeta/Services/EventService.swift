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

    func postNewEvent(
        title: String,
        description: String,
        isAllDay: Bool,
        startDateTime: Date,
        endDateTime: Date,
        closingDateTime: Date,
        locationName: String,
        cost: Int,
        message: String,
        latitude: Double,
        longitude: Double
    ) async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let startTime = dateFormatter.string(from: startDateTime)
        let endTime = dateFormatter.string(from: endDateTime)
        let closingTime = dateFormatter.string(from: closingDateTime)

        let request = EventEditingRequest(
            title: title,
            description: description,
            is_all_day: isAllDay,
            start_time: startTime,
            end_time: endTime,
            closing_time: closingTime,
            location_name: locationName,
            cost: cost,
            message: message,
            author_id: UserDefaults.standard.integer(forKey: "userid"),
            latitude: "\(latitude)",
            longitude:"\(longitude)"
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
        let voteRequest = VoteRequest(eventid: eventid, option: option)
        
        do {
            let response = try await APIClient.shared.call(request: voteRequest)
            if response.isSuccess {
                print("投票に成功しました")
            } else {
                print("投票に失敗しました")
            }
        } catch {
            print("投票中にエラーが発生しました: \(error)")
        }
    }
    
    func deleteEvent(eventid: Int) async {
        let deleteRequest = EventDeleteRequest(eventid: eventid)
        print("イベント削除リクエスト: \(deleteRequest)")

        do {
            let response = try await APIClient.shared.call(request: deleteRequest)
            print("イベント削除レスポンス: \(response)")
            if response.isSuccess {
                print("イベント削除に成功しました")
            } else {
                print("イベント削除に失敗しました")
            }
        } catch {
            print("イベント削除中にエラーが発生しました: \(error)")
        }
    }
}
