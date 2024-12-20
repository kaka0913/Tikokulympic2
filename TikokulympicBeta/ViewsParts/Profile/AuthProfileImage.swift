//
//  AuthProfileImage.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/23.
//

import SwiftUI

struct AuthProfileImage: View {
    @Environment(\.signupUserProfileModel) var signupUserProfileModel: SignupUserProfileModel
    @State private var isShowingImagePicker = false
    let userid = UserDefaults.standard.integer(forKey: "userid")
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let image = signupUserProfileModel.uploadedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .onTapGesture {
                        isShowingImagePicker = true
                    }
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            }
            
            Image(systemName: "camera.circle.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
                .background(Color.black.opacity(0.7))
                .clipShape(Circle())
                .padding(2)
                .onTapGesture {
                    isShowingImagePicker = true
                }
        }
        .onChange(of: signupUserProfileModel.selectedImage) {
            Task {
                try await signupUserProfileModel.uploadImage(userid: userid)
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker()
        }
    }

}
