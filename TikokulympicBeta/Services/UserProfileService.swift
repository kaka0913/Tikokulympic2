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

    func getProfile(userId: Int) async {
        let request = UserProfileRequest(userId: userId)
        do {
            let response = try await apiClient.call(request: request)
        } catch {
            print("ユーザプロフィールの取得に失敗しました: \(error)")
        }
    }
}


