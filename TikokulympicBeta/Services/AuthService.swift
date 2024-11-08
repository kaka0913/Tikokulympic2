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
    
    func postSignup(token: String, userName: String, authId: String) async throws -> SignupResponse {
        let request = SignupRequest(
            user_name: userName,
            auth_id: authId,
            token: token
        )
        do {
            return try await apiClient.call(request: request)
        } catch {
            print("サインアップに失敗しました: \(error)")
            throw error
        }
    }
    
    func postSignin(id: String) async throws -> SigninResponse {
        let request = SigninRequest(id: id)
        do {
            return try await apiClient.call(request: request)
        } catch {
            print("サインインに失敗しました: \(error)")
            throw error
        }
    }
}
