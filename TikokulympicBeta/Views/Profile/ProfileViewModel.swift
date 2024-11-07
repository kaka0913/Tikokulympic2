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
            await downloadProfileImage()
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
    
    // 選択した画像をアップロードする関数
    func uploadImage() {
        guard let image = selectedImage,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        let userid = UserDefaults.standard.integer(forKey: "userid")

        isUploading = true
        Task {
            do {
                try await supabaseService.uploadImage(
                    imageData: imageData,
                    userid: userid
                )
                // アップロード成功後、画像をダウンロードして表示
                await downloadProfileImage()
            } catch {
                print("画像のアップロードに失敗しました: \(error)")
            }
            DispatchQueue.main.async {
                self.isUploading = false
            }
        }
    }

    // プロファイル画像をダウンロードする関数
    func downloadProfileImage() async {
        isDownloading = true
        do {
            let userid = UserDefaults.standard.integer(forKey: "userid")
            let data = try await supabaseService.downloadProfileImage(userid: String(userid))
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.uploadedImage = image
                }
            } else {
                print("データを画像に変換できませんでした。")
            }
        } catch {
            print("プロフィール画像のダウンロードに失敗しました: \(error)")
        }
        DispatchQueue.main.async {
            self.isDownloading = false
        }
    }
}
