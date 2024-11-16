//
//  SignUpView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/27.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.signupUserProfileModel) private var signupUserProfileModel: SignupUserProfileModel
    @State private var isShowingImagePicker = false
    @State private var userName: String = ""
    @State private var realName: String = ""
    @State private var showToast = false

    var body: some View {
        VStack () {
            Image("TikokuGorin")
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 80)
                .padding(.top, -40)

            Text("プロフィールを登録しましょう")
                .padding()
                .font(.title2)
            
            TextField("ユーザーネームを入力", text: $userName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("本名を入力", text: $realName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if let selectedImage = signupUserProfileModel.selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } else {
                Text("画像が選択されていません")
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
            }

            Button(action: {
                isShowingImagePicker = true
            }) {
                Text("アイコンをえらぶ")
                    .padding(.vertical, 12)
                    .padding(.horizontal, 45)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker()
            }
            .padding(.bottom, 20)
            .padding(.top, 20)

            Button(action: {
                Task {
                    do {
                        try await signupUserProfileModel.registerNewUser(userName: userName, realName: realName)
                    } catch {
                        signupUserProfileModel.errorMessage = error.localizedDescription
                    }
                    
                    if signupUserProfileModel.errorMessage != nil {
                        withAnimation {
                            showToast = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                showToast = false
                            }
                        }
                    }
                }
            }) {
                Text("アプリを開始する")
                    .padding(.vertical, 12)
                    .padding(.horizontal, 50)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
        }
        .padding()
        .navigationBarHidden(true)

        if showToast, let errorMessage = signupUserProfileModel.errorMessage {
            Text(errorMessage)
            .foregroundColor(.white)
            .padding()
            .background(Color.red.opacity(0.8))
            .cornerRadius(10)
            .shadow(radius: 5)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .transition(.slide)
            .animation(.easeInOut, value: showToast)
        }
        
    }
}
