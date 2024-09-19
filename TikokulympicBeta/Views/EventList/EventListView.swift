//
//  EventListView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/07.
//

import SwiftUI
import Supabase

struct Users: Codable {
    let id: Int
    let created_at: String
    let name: String
    let auth_id: Int?
    let token: String?
}


struct EventListView: View {
    @State private var title: String = "タイトルを取得してください"
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.headline)
            
            if let errorMessage = errorMessage {
                Text("エラー: \(errorMessage)")
                    .foregroundColor(.red)
            }
            Button(action:  {
                Task {
                    do {
                        let currentDate = Date()
                        let isoFormatter = ISO8601DateFormatter()
                        let isoTimestamp = isoFormatter.string(from: currentDate)
                        guard let supabaseURL = APIKeyManager.shared.apiKey(for: "SUPABASE_URL"),
                            let supabaseApiKey = APIKeyManager.shared.apiKey(for: "SUPABASE_API_KEY")
                        else {
                            debugPrint("Supabase URL or API Key not found")
                            return
                        }
                        
                        
                        

                        debugPrint("SupabaseClient initialized")
                        
                        let user = Users(id: 101, created_at: "2024-09-11 03:39:24.655264+00", name: "Dekakakakkanmark", auth_id: 100, token: "hogegge")


                        let response: [Users]? = try await SupabaseClientManager.shared.client?
                            .from("users")
                            .select("*")
                            .execute()
                            .value
                        
                  
                        
                        if let response {
                            print(response)
                        }
                        // 最初のオプションを取得
                        guard let option = response.self else {
                            throw NSError(domain: "SupabaseService", code: 404, userInfo: [NSLocalizedDescriptionKey: "該当するデータが見つかりません。"])
                        }
                        
                        print(option)
                        print(option.self)
                        // UIを更新
//                        DispatchQueue.main.async {
//                            self.title = option.title
//                            self.errorMessage = nil
//                        }
                        
                    } catch {
                        // エラーハンドリング
                        DispatchQueue.main.async {
                            self.errorMessage = error.localizedDescription
                            self.title = "タイトルの取得に失敗しました"
                        }
                        print("タイトルの取得中にエラーが発生しました: \(error.localizedDescription)")
                    }
                }
            }) {
                Text("タイトルを取得")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}
