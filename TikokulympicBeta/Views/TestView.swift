//
//  TestView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/23.
//

import Foundation
import SwiftUI

struct ProfileImageView: View {
    @State private var isShowingImagePicker = false
    @Environment(\.userProfileModel) var userProfileModel: UserProfileModel
    
    var body: some View {
        VStack(spacing: 20) {
            // アップロードされた画像があれば表示
            if let image = userProfileModel.uploadedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .shadow(radius: 10)
            } else {
                // プレースホルダー画像
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width: 200, height: 200)
            }

            // 画像選択ボタン
            Button(action: {
                isShowingImagePicker = true
            }) {
                Text("画像を選択")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }

            // 選択された画像のプレビュー
            if let selectedImage = userProfileModel.selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            // 画像アップロードボタン
            Button(action: {
                userProfileModel.uploadImage()
            }) {
                if userProfileModel.isUploading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(width: 100, height: 50)
                        .background(Color.blue)
                        .cornerRadius(8)
                } else {
                    Text("画像をアップロード")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .disabled(userProfileModel.selectedImage == nil || userProfileModel.isUploading)

            // ダウンロード中のインジケーター
            if userProfileModel.isDownloading {
                ProgressView("画像を読み込み中...")
            }

            // エラーメッセージの表示
            if let errorMessage = userProfileModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }

            Spacer()
        }
        .padding()
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker()
        }
        .onChange(of: userProfileModel.selectedImage) {
            userProfileModel.uploadImage()
        }
        .onAppear() {
            Task {
               await userProfileModel.downloadProfileImage()
            }
        }
    }
}
