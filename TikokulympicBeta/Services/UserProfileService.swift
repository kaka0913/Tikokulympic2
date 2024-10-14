//
//  UserProfileService.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/22.
//

import Alamofire
import Foundation

class UserProfileService {
    private let apiClient = APIClient.shared
    static let shared = UserProfileService()
   
    func getProfile() async throws -> UserProfileResponse {
        let userid = UserDefaults.standard.integer(forKey: "userid")
        let request = UserProfileRequest(userid: 1) //TODO: useridを取得する処理に戻す
        do {
           return try await apiClient.call(request: request)
        } catch {
            print("ユーザプロフィールの取得に失敗しました: \(error)")
            throw error
        }
    }
}


