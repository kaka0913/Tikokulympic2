import Foundation
import SwiftUI

struct SignupUserProfileModelKey: EnvironmentKey {
    // デフォルト値が指定できる
    static let defaultValue: SignupUserProfileModel = SignupUserProfileModel.shared
}

extension EnvironmentValues {
    var signupUserProfileModel: SignupUserProfileModel {
        get { self[SignupUserProfileModelKey.self] }
        set { self[SignupUserProfileModelKey.self] = newValue }
    }
}


@Observable
class SignupUserProfileModel {
    static let shared = SignupUserProfileModel()

    var userName: String?
    var realName: String?
    var fcmtoken: String?
    var selectedImage: UIImage? // ユーザーが選択した画像
    var uploadedImage: UIImage? // Supabaseからダウンロードした画像
    var isUploading: Bool = false
    var isDownloading: Bool = false
    var errorMessage: String? // エラーメッセージ表示用
    var profile: UserProfileResponse?
    var authid: String = ""

    private let supabaseService = SupabaseService.shared
    let authService = AuthService.shared
    let userProfileService = UserProfileService()

    init() {
        let userid = UserDefaults.standard.integer(forKey: "userid")
        if userid != 0 {
            Task {
                await downloadProfileImage()
            }
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
            
        do {

            let fcmToken = UserDefaults.standard.string(forKey: "fcmToken")
            let response = try await authService.postSignup(
                token: fcmToken ?? "getfcmtokenFailure",
                userName: userName,
                authId: authid
            )
            try await uploadImage(userid: response.id)
            UserDefaults.standard.set(response.id, forKey: "userid")
            
        } catch {
            print("ユーザ登録に失敗しました: \(error.localizedDescription)")
            self.errorMessage = "ユーザ登録に失敗しました: \(error.localizedDescription)"
        }
    }
    
    // 選択した画像をアップロードする関数
    func uploadImage(userid: Int) async throws {
        guard let image = selectedImage,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "アップロードする画像を選択してください。"])
        }

        isUploading = true
        defer { isUploading = false }
        
        do {
            try await supabaseService.uploadImage(
                imageData: imageData,
                userid: userid
            )
            print("画像のアップロードに成功しました")
            // アップロード成功後、画像をダウンロードして表示
            await downloadProfileImage()
        } catch {
            self.errorMessage = "アップロードに失敗しました: \(error.localizedDescription)"
            print("アップロードエラーの詳細: \(error)")
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
                DispatchQueue.main.async {
                    self.errorMessage = "データを画像に変換できませんでした。"
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "ユーザプロフィールのダウンロードに失敗しました: \(error.localizedDescription)"
            }
        }
        DispatchQueue.main.async {
            self.isDownloading = false
        }
    }
}
