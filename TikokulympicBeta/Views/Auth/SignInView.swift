//
//  SignIn.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/27.
//

import SwiftUI

struct SignInView: View {
    @Environment(\.userProfileModel) private var userProfileModel: UserProfileModel
    @State private var userName: String = ""
    @State private var realName: String = ""
    @State private var showToast = false

    var body: some View {
        VStack () {
            Image("TikokuGorin")
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 80)
                .padding(.top, -120)

            TextField("ユーザーネームを入力", text: $userName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("本名を入力", text: $realName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                Task {
                    do {
                        //TODO: サインアップの処理
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
                Text("ログイン")
                    .padding(.vertical, 12)
                    .padding(.horizontal, 45)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.top, 20)
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

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environment(\.userProfileModel, UserProfileModel())
    }
}
