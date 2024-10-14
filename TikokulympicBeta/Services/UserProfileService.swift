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
        let request = UserProfileRequest(userid: userid)
        do {
           return try await apiClient.call(request: request)
        } catch {
            //しょうまがAPI直すまでこのエラーを無視する
            //print("ユーザプロフィールの取得に失敗しました: \(error)")
            throw error
        }
    }
}


