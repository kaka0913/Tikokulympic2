//
//  ProfileView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/07.
//
import SwiftUI

struct ProfileView: View {
    @StateObject var vm = ProfileViewModel()
    @State private var isShowingImagePicker = false
    
    // Mock data
    let userName = "あああ"
    let lateCount = 2
    let onTimeCount = 0
    let totalLateTime = "1h20m"
    let title = "警察なのに遅刻"
    
    @Environment(\.userProfileModel) var userProfileModel: UserProfileModel

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("称号")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding(.trailing, 8)

                Text(title)
                    .foregroundColor(.white)
                    .font(.headline)
            }
            .padding(.top, 16)

            VStack(spacing: 20) {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            ZStack(alignment: .topTrailing) {
                                if let image = userProfileModel.uploadedImage {
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

                            Text("名前: \(userName)")
                                .font(.title3)
                            Image(systemName: "pencil")
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "clock.fill")
                                Text("遅刻回数: \(lateCount)")
                                    .font(.title2)
                            }

                            HStack {
                                Image(systemName: "hand.raised.fill")
                                Text("間に合った回数: \(onTimeCount)")
                                    .font(.title2)
                            }

                            HStack {
                                Image(systemName: "hourglass.bottomhalf.fill")
                                Text("総遅刻時間: \(totalLateTime)")
                                    .font(.title2)
                            }
                            Spacer()
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .padding(.horizontal)
            }
            .padding(.top, 20)

            Spacer()
        }
        .background(Color.green)
        .cornerRadius(20)
        .padding(.all, 10)
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker()
        }
        .onAppear {
            Task {
                await userProfileModel.downloadProfileImage()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
