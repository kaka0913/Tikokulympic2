import Foundation

struct Event: Decodable, Identifiable {
    var id = UUID()
    let author: Author? // JSONのキー名に合わせる
    let title: String
    let description: String
    let isAllDay: Bool
    let startDateTime: Date  // JSONのキー名に合わせる
    let endDateTime: Date // JSONのキー名に合わせる
    let closingDateTime: Date// JSONのキー名に合わせる
    let locationName: String
    let latitude: Double // JSONに合わせて型を修正
    let longitude: Double // JSONに合わせて型を修正
    let cost: Double // JSONに合わせて型を修正
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
    let authorId: Int? // JSONのキー名に合わせる
    let authorName: String? // JSONのキー名に合わせる
    private enum CodingKeys: String, CodingKey {
        case authorId = "authorId"
        case authorName = "authorName"
    }
}

struct Participants: Decodable, Identifiable {
    var id = UUID()
    let participants: [Participant]?
    let status: ParticipationStatus? // `ParticipationStatus`の定義が必要
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
