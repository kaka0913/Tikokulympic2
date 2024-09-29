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
        } catch {
            throw error
        }
    }
}

class MockViewModelInfo: ObservableObject {
    @Published var events: [Event] = []

    init(events: [Event]) {
            self.events = events
        }

        // convenienceイニシャライザ
        convenience init() {
            let defaultAuther = Auther(autherId: 111, autherName: "Author Name")
            let defaultParticipant = Participant(name: "しゅうと", status: .participating)
            let defaultOption = Option(title: "参加", participantCount: 11, participants: [defaultParticipant])

            let defaultEvent = Event(
                auther: defaultAuther,
                title: "Sample Event Title",
                description: "This is a sample event description.",
                isAllDay: false,
                startTime: Date(),
                endTime: Calendar.current.date(byAdding: .hour, value: 2, to: Date())!,
                closingTime: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                locationName: "Event Location",
                cost: 1000,
                message: "This is an event message.",
                managerId: 1,
                latitude: "35.6895", // 緯度（東京）
                longitude: "139.6917", // 経度（東京）
                options: defaultOption
            )

            // メインのイニシャライザを呼び出し
            self.init(events: [defaultEvent])
        }
}
