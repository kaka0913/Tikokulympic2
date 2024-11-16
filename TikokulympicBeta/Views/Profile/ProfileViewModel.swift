//
//  ProfileViewModel.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/11/02.
//

import Foundation
import CoreLocation
import SwiftUI
import FirebaseAuth

class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfileResponse?
    @Published var lateTimeRanking: [LateTimeRankingData]?
    @Published var lateCountRanking: [LateCountRankingData]?
    @Published var latePointRanking: [LatePointRankingData]?

    let userProfileService = UserProfileService()
    let totalUserRankingService = TotalUserRankingService()
    
    func signOut() {
        do {
            UserDefaults.standard.removeObject(forKey: "userid")
            try Auth.auth().signOut()
            print("ログアウトしました")
        } catch {
            print("ログアウトに失敗しました: \(error)")
        }
    }
    
    @MainActor
    func fetchProfile() async {
        do {
            let profile = try await userProfileService.getProfile()
            self.profile = profile
            print("プロフィールの取得に成功しました")
        } catch {
            print("プロフィールの取得に失敗しました: \(error)")
        }
    }
    
    @MainActor
    func getRankings() async {
        do {
            let lateTimeRanking = try await totalUserRankingService.getTotalTimeRanking()
            self.lateTimeRanking = lateTimeRanking
            print("遅刻時間ランキングの取得に成功しました")
            
            let lateCountRanking = try await totalUserRankingService.getLateCountRanking()
            self.lateCountRanking = lateCountRanking
            print("遅刻回数ランキングの取得に成功しました")
            
            let latePointRanking = try await totalUserRankingService.getLatePointRanking()
            self.latePointRanking = latePointRanking
            print("遅刻ポイントランキングの取得に成功しました")
        } catch {
            print("ランキングの取得に失敗しました: \(error)")
        }
    }
}
