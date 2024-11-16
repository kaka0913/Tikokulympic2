//
//  NameEditView.swift
//  TikokulympicBeta
//
//  Created by 牟禮優汰 on 2024/11/16.
//

import SwiftUI

struct NameEditView: View {
    @StateObject private var viewModel = NameEditViewModel()
    @State var isShowNameEditAlert = false
    @State var LastCheckNameEditAlert = false
    @State private var NameEdit = ""
    @State private var isSaving = false // 保存中の状態管理
    @State private var showAlert = false // エラー表示用
    @State private var errorMessage: String = "" // エラー内容
    
    var body: some View {
        VStack{
            if let profile = viewModel.profile {
                Button {
                    isShowNameEditAlert = true
                } label: {
                    Image(systemName: "pencil")
                }
                .alert("ニックネーム編集", isPresented: $isShowNameEditAlert) {
                    TextField("新規ニックネーム", text: $NameEdit)
                    Button("キャンセル") {}
                    Button("OK") {
                        if NameEdit.isEmpty {
                            showAlert = true
                            errorMessage = "ニックネームは空欄にできません。"
                        } else {
                            LastCheckNameEditAlert = true
                        }
                    }
                }
                .alert("本当に変更してもよろしいですか?", isPresented: $LastCheckNameEditAlert) {
                    Button("キャンセル") {}
                    Button("OK") {
                        viewModel.updateUserName(userId: profile.userId, newName: NameEdit)
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("エラー"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
                if viewModel.isSaving {
                    ProgressView("保存中...")
                }
            } else {
                Text("プロフィールが読み込まれていません")
            }
        }
            .onAppear {
                Task {
                    await viewModel.fetchProfile()
                }
            }
        }
}
