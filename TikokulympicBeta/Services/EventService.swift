//
//  EventService.swift
//  TikokulympicBeta
//
//  Created by 澤木柊斗 on 2024/09/26.
//

import Foundation

final class EventService {
    let apiClient = APIClient.shared
    static let shered = EventService()

    func fetchEvents() async throws -> EventsResponse {
        let request = EventsRequest()

        do {
            let response = try await apiClient.call(request: request)
            return response
        } catch {
            throw error
        }
    }
}
