//
//  SupabaseService.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/18.
//

import Foundation
import Supabase

class SupabaseClientManager {
    static let shared = SupabaseClientManager()
    var client: SupabaseClient?

    private init() {
        guard let supabaseURL = APIKeyManager.shared.apiKey(for: "SUPABASE_URL"),
            let supabaseApiKey = APIKeyManager.shared.apiKey(for: "SUPABASE_API_KEY")
        else {
            debugPrint("Supabase URL or API Key not found")
            return
        }

        client = SupabaseClient(supabaseURL: URL(string: supabaseURL)!, supabaseKey: supabaseApiKey)
        debugPrint("SupabaseClient initialized")
    }
}
