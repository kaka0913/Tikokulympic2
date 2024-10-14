import Foundation

struct Event: Decodable, Identifiable {
    var id = UUID()
    let author: Author?
    let title: String
    let description: String
    let isAllDay: Bool
    let startDateTime: Date
    let endDateTime: Date
    let closingDateTime: Date
    let locationName: String
    let latitude: Double
    let longitude: Double
    let cost: Double
    let message: String
    let options: [Option]?
    private enum CodingKeys: String, CodingKey {
        case author,
             title,
             description,
             isAllDay = "isAllDay",
             startDateTime = "startDateTime",
             endDateTime = "endDateTime",
             closingDateTime = "closingDateTime",
             locationName = "locationName",
             latitude,
             longitude,
             cost,
             message,
             options
    }
}

struct Option: Decodable, Identifiable {
    var id = UUID()
    let title: String
    let participantCount: Int
    let participants: Participants?
    private enum CodingKeys: String, CodingKey {
        case title
        case participantCount = "participantCount"
        case participants
    }

}

struct Author: Decodable, Identifiable {
    var id = UUID()
    let authorId: Int?
    let authorName: String?
    private enum CodingKeys: String, CodingKey {
        case authorId = "authorId"
        case authorName = "authorName"
    }
}

struct Participants: Decodable, Identifiable {
    var id = UUID()
    let participants: [Participant]?
    let status: ParticipationStatus?
    private enum CodingKeys: String, CodingKey {
        case participants
        case status
    }

}

struct Participant: Decodable, Identifiable {
    let id = UUID()
    let userId: Int?
    let name: String?
    private enum CodingKeys: String, CodingKey {
        case name = "userName"
        case userId = "userId"
    }

}
