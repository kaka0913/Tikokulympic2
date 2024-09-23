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
    static let defaultValue: UserProfileModel = UserProfileModel()
}

extension EnvironmentValues {
    var userProfileModel: UserProfileModel {
        get { self[UserProfileModelKey.self] }
        set { self[UserProfileModelKey.self] = newValue }
    }
}


@Observable
class UserProfileModel {
    var selectedImage: UIImage? // ユーザーが選択した画像
    var uploadedImage: UIImage? // Supabaseからダウンロードした画像
    var isUploading: Bool = false
    var isDownloading: Bool = false
    var errorMessage: String? // エラーメッセージ表示用

    private let supabaseService = SupabaseService()
    private let userID = 1 //TODO: ここを修正

    init() {
        Task {
            await downloadProfileImage()
        }
    }

    // 選択した画像をアップロードする関数
    func uploadImage() {
        guard let image = selectedImage,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            self.errorMessage = "アップロードする画像を選択してください。"
            return
        }

        isUploading = true
        Task {
            do {
                let userid = 1 //TODO: 修正
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
            let data = try await supabaseService.downloadProfileImage(userID: userID)
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
