//
//  EventListViewModel.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/23.
//

import Foundation

class EventListViewModel: ObservableObject {
    @Published var event: Event
    @Published var participants: [Participant]
    
    init(event: Event, participants: [Participant]) {
        self.event = event
        self.participants = participants
    }
}
