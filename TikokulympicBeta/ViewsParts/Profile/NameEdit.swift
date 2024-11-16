import SwiftUI

struct NameEditView: View{
    @State var isShowNameEditAlert = false
    @State var LastCheckNameEditAlert = false
    @State private var NameEdit = ""
    @State private var isSaving = false // 保存中の状態管理
    @State private var showAlert = false // エラー表示用
    @State private var errorMessage: String = "" // エラー内容
    @StateObject private var viewNameModel = ProfileViewModel()

    var Body: some View {
        if let profile = viewModel.profile {
            Button{
                isShowNameEditAlert = true
                
            } label: {
                Image(systemName: "pencil")
            }
            .alert("ニックネーム編集", isPresented: $isShowNameEditAlert) {
                TextField("新規ニックネーム", text: $NameEdit)
                Button("キャンセル") {
                }
                Button ("OK"){
                    LastCheckNameEditAlert=true
                }
            }
            .alert("本当に変更してもよろしいですか?", isPresented: $LastCheckNameEditAlert) {
                Button("キャンセル") {
                }
                Button("OK") {
                    viewModel.updateUserName(userId: profile.id, newName: NameEdit)
                }
            }
        }
    }
}
