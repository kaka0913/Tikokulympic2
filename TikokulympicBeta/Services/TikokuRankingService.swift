//
//  TikokuRankingService.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/17.
//

import Alamofire
import Foundation

class TikokuRankingService {
    private let apiClient = APIClient.shared
    static let shared = TikokuRankingService()

    func postArrival(userId: String, eventId: String, isArrival: Bool, arrivalTime: Date) async {
        let request = ArrivalRequest(
            eventId: eventId,
            userId: userId,
            isArrival: isArrival,
            arrivalTime: arrivalTime
        )
        do {
            let response = try await apiClient.call(request: request)
        } catch {
            print("イベント会場到着情報の送信に失敗しました: \(error)")
        }
    }
}
