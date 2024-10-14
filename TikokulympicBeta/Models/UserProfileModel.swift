//
//  UserProfileModel.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/23.
//

import Foundation
import Combine
import SwiftUI

struct UserProfileModelKey: EnvironmentKey {
    // デフォルト値が指定できる
    static let defaultValue: UserProfileModel = UserProfileModel.shared
}

extension EnvironmentValues {
    var userProfileModel: UserProfileModel {
        get { self[UserProfileModelKey.self] }
        set { self[UserProfileModelKey.self] = newValue }
    }
}


@Observable
class UserProfileModel {
    static let shared = UserProfileModel()

    var userName: String?
    var realName: String?
    var fcmtoken: String?
    var selectedImage: UIImage? // ユーザーが選択した画像
    var uploadedImage: UIImage? // Supabaseからダウンロードした画像
    var isUploading: Bool = false
    var isDownloading: Bool = false
    var errorMessage: String? // エラーメッセージ表示用
    var profile: UserProfileResponse?

    private let supabaseService = SupabaseService()
    let authService = AuthService.shared
    let userProfileService = UserProfileService()

    init() {
        Task {
            await downloadProfileImage()
            await fetchProfile()
        }
    }
    
    @MainActor
    func fetchProfile() async {
        do {
            let profile = try await userProfileService.getProfile()
            self.profile = profile
            print("プロフィールの取得に成功しました")
            print("profile: \(String(describing: self.profile))")
        } catch {
            self.errorMessage = "プロフィールの取得に失敗しました: \(error.localizedDescription)"
            print("プロフィールの取得に失敗しました: \(error)")
        }
    }
 
    //TODO: realNameをまだ登録できない
    func registerNewUser(userName: String, realName: String) async throws {
        //文字のバリデーション
        guard !userName.isEmpty,
              !realName.isEmpty else {
            self.errorMessage = "ユーザーネームと本名を入力してください。"
            return
        }
        
        self.userName = userName
        self.realName = realName

        //画像のバリデーション
        guard self.selectedImage != nil else {
            self.errorMessage = "画像を選択してください。"
            return
        }
            
        Task {
            do {
                let fcmToken = UserDefaults.standard.string(forKey: "fcmToken")

                let authId = 123 //TODO: authIDを取得する必要あり
                
                let response = try await authService.postSignup(
                    token: fcmToken ?? "getfcmtokenFailure ",
                    userName: userName,
                    authId: authId
                )
                
                
                UserDefaults.standard.set(response.id, forKey: "userid")
                
                self.uploadImage()
                
            } catch {
                self.errorMessage = "登録に失敗しました: \(error.localizedDescription)"
            }
        }
    }
    
    // 選択した画像をアップロードする関数
    func uploadImage() {
        guard let image = selectedImage,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            self.errorMessage = "アップロードする画像を選択してください。"
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
                DispatchQueue.main.async {
                    self.errorMessage = "アップロードに失敗しました: \(error.localizedDescription)"
                }
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
            let data = try await supabaseService.downloadProfileImage(userid: userid)
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.uploadedImage = image
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "データを画像に変換できませんでした。"
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "ダウンロードに失敗しました: \(error.localizedDescription)"
            }
        }
        DispatchQueue.main.async {
            self.isDownloading = false
        }
    }
}
