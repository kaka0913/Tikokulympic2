//
//  EventListViewModel.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/23.
//

import Foundation

class EventListViewModel: ObservableObject {
    @Published var events: [Event] = []
    let service = EventService.shared

    @MainActor
    func getEvents() async {
        do {
            let response = try await service.fetchEvents()
            events = response.events
            print("イベントの表示に成功しました：\(events)")
        } catch {
            print("イベントの表示中にエラーが発生しました: \(error)")
        }
    }
}
