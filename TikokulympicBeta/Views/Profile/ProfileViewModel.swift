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
    var selectedImage: UIImage? // ユーザーが選択した画像
    var uploadedImage: UIImage? // Supabaseからダウンロードした画像
    var isUploading: Bool = false
    var isDownloading: Bool = false
    @Published var profile: UserProfileResponse?

    private let supabaseService = SupabaseService.shared
    let userProfileService = UserProfileService()

    init() {
        Task {
            await fetchProfile()
        }
    }
    
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
            print(profile)
        } catch {
            print("プロフィールの取得に失敗しました: \(error)")
        }
    }
}
