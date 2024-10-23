//
//  EventListViewModel.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/23.
//

import Foundation

class EventListViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading: Bool = false
    let service = EventService.shared

    @MainActor
    func getEvents() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let response = try await service.fetchEvents()
            events = response.events
            print("イベントの表示に成功しました")
        } catch {
            print("イベントの表示中にエラーが発生しました: \(error)")
        }
    }
    
    @MainActor
    func putVote(eventid: Int, option: String) async {
        await service.putVote(eventid: eventid, option: option)
    }
    
    @MainActor
    func deleteEvent(eventid: Int) async {
        isLoading = true
        defer { isLoading = false }
        await service.deleteEvent(eventid: eventid)
    }
}

