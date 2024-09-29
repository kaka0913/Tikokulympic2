//
//  Event.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/23.
//

import Foundation

struct Event: Decodable, Identifiable {
    var id = UUID()
    let auther: Auther
    let title: String
    let description: String
    let isAllDay: Bool
    let startTime: Date
    let endTime: Date
    let closingTime: Date
    let locationName: String
    let cost: Int
    let message: String
    let managerId: Int
    let latitude: String
    let longitude: String
    let options: Option
}

struct Option: Decodable, Identifiable {
    var id = UUID()
    let title: String
    let participantCount: Int
    let participants: [Participant]
}

struct Auther: Decodable, Identifiable {
    var id = UUID()
    let autherId: Int
    let autherName: String
}

struct Participant: Decodable , Identifiable {
    var id = UUID()
    let name: String
    let status: ParticipationStatus
}
