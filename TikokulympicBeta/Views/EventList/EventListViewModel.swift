//
//  EventListViewModel.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/23.
//

import Foundation

class EventListViewModel: ObservableObject {
    @Published var events: [Event] = []
    let service = EventService.shered


    @MainActor
    func getEvents() async throws -> Void {
        do {
            let response = try await service.fetchEvents()
            events = response.events
            print("\(events)")
        } catch {
            throw error
        }
    }
}
