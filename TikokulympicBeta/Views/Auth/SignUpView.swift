//
//  SignUpView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/27.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.userProfileModel) private var userProfileModel: UserProfileModel
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

            TextField("ユーザーネームを入力", text: $userName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("本名を入力", text: $realName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if let selectedImage = userProfileModel.selectedImage {
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
                Text("画像を選択")
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
                        try await userProfileModel.registerNewUser(userName: userName, realName: realName)
                    } catch {
                        userProfileModel.errorMessage = error.localizedDescription
                    }
                    
                    if userProfileModel.errorMessage != nil {
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
                Text("新規登録")
                    .padding(.vertical, 12)
                    .padding(.horizontal, 50)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
        }
        .padding()

        if showToast, let errorMessage = userProfileModel.errorMessage {
            VStack {
                Spacer()

                Text(errorMessage)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
            .transition(.slide)
            .animation(.easeInOut, value: showToast)
        }
        
    }
}



struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environment(\.userProfileModel, UserProfileModel())
    }
}
