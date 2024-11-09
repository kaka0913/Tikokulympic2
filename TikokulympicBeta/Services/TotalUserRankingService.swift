//
//  OverallRankingService.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/11/09.
//

import Foundation

class TotalUserRankingService {
    private let apiClient = APIClient.shared
    
    func getTotalTimeRanking() async throws -> [LateTimeRankingData] {
        let request = LateTimeRankingRequest()
        
        do {
            let response = try await apiClient.call(request: request)
            print("時間ランキングの取得に成功")
            return response.ranking
        } catch {
            print("時間ランキング取得に失敗: \(error)")
            throw error
        }
    }
    
    func getLateCountRanking() async throws -> [LateCountRankingData] {
        let request = LateCountRankingRequest()
        
        do {
            let response = try await apiClient.call(request: request)
            print("遅刻回数ランキングの取得に成功")
            return response.ranking
        } catch {
            print("遅刻回数ランキングの取得に失敗: \(error)")
            throw error
        }
    }
    
    func getLatePointRanking() async throws -> [LatePointRankingData] {
        let request = LatePointRankingRequest()
        
        do {
            let response = try await apiClient.call(request: request)
            print("遅刻ポイントランキングの取得に成功")
            return response.ranking
        } catch {
            print("遅刻ポイントランキングの取得に失敗: \(error)")
            throw error
        }
    }
}
