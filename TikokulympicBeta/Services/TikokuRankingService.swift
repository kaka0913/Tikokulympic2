//
//  TikokuRankingService.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/10/23.
//

import Foundation

class TikokuRankingService {
    private let apiClient = APIClient.shared
    static let shared = TikokuRankingService()
    
    func getArrivaiRanking(eventid: Int) async throws -> ArrivalRankingResponse {
        let request = ArrivalRankingRequest(eventid: eventid)
        
        do {
            let response = try await apiClient.call(request: request)
            print("到着者リストの取得に成功しました")
            return response
        } catch {
            print("イベント取得に失敗しました: \(error)")
            throw error
            
        }
    }
}
