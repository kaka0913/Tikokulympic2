//
//  AuthService.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/22.
//

import Foundation

class AuthService {
    private let apiClient = APIClient.shared
    static let shared = AuthService()
    
    func postSignup(token: String, userName: String, authId: Int) async throws -> SignupResponse {
        let request = SignupRequest(
            token: token,
            user_name: userName,
            auth_id: authId
        )
        do {
            return try await apiClient.call(request: request)
        } catch {
            print("サインアップに失敗しました: \(error)")
            throw error
        }
    }
}
