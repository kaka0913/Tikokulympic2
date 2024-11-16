//
//  SupabaseService.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/18.
//

import Foundation
import Supabase

class SupabaseService {
    static let shared = SupabaseService()
    let client: SupabaseClient
    let auth: AuthClient

    private init() {
        guard let supabaseURLString = APIKeyManager.shared.apiKey(for: "SUPABASE_URL"),
              let supabaseApiKey = APIKeyManager.shared.apiKey(for: "SUPABASE_API_KEY"),
              let supabaseURL = URL(string: supabaseURLString) else {
            fatalError("Supabase URL or API Key not found")
        }
        self.client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabaseApiKey)
        self.auth = client.auth
    }
    
    func uploadImage(imageData: Data, userid: Int) async throws {
        let storage = client.storage.from("profileImages")
        let filePath = "images/\(userid)"
        let options = FileOptions(cacheControl: "3600", upsert: true)//同じパスであれば画像の上書きを実行する

        do {
            let response = try await storage.upload(
                path: filePath,
                file: imageData,
                options: options
            )
            print("画像のアップロードに成功しました: \(response)")
        } catch {
            print("画像のアップロードに失敗しました: \(error.localizedDescription)")
            throw error
        }
    }
    
    func downloadProfileImage(userid: String) async throws -> Data {
        let storage = client.storage.from("profileImages")
        let filePath = "images/\(userid)"
        let url = try await storage.createSignedURL(path: filePath, expiresIn: 60 * 60) // 1時間有効なURLを取得
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
