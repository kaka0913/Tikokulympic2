import SwiftUI

class NameEditViewModel: ObservableObject {
    @Published var profile: UserNameEditRequest?
    @Published var isSaving = false
    @Published var showErrorAlert = false
    @Published var errorMessage: String = ""
    private let userService = UserService() // UserServiceインスタンス化

    func fetchProfile() {
        // プロフィールがnilの場合にはエラーメッセージを表示
        guard let userId = profile?.userId else {
            self.errorMessage = "ユーザーIDが取得できません"
            self.showErrorAlert = true
            return
        }
        
        userService.getUserProfile(userId: userId) { result in
            switch result {
            case .success(let fetchedProfile):
                DispatchQueue.main.async {
                    self.profile = fetchedProfile
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "プロフィールの取得に失敗しました: \(error.localizedDescription)"
                    self.showErrorAlert = true
                }
            }
        }
    }

    func updateUserName(userId: Int, newName: String) {
        // 名前が空の場合、エラーメッセージを表示
        guard !newName.isEmpty else {
            self.errorMessage = "ニックネームは空にできません"
            self.showErrorAlert = true
            return
        }
        
        isSaving = true
        userService.updateUserName(userId: userId, name: newName) { result in
            switch result {
            case .success(let isSuccess):
                DispatchQueue.main.async {
                    if isSuccess {
                        // 更新成功時にプロファイルの名前を更新
                        self.profile?.name = newName
                    } else {
                        self.errorMessage = "ニックネームの更新に失敗しました。"
                        self.showErrorAlert = true
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "エラーが発生しました: \(error.localizedDescription)"
                    self.showErrorAlert = true
                }
            }
            self.isSaving = false
        }
    }
}
