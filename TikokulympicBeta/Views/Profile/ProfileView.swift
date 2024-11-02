//
//  ProfileView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/07.
//
import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var isDrawerOpen = false
    @State private var isNotificationsEnabled = false
    @State private var isLocationEnabled = false
    @State private var showSignOutConfirmation = false
    
    var body: some View {
        if let profile = viewModel.profile {
            ZStack {
                VStack {
                    VStack(spacing: 0) {
                        VStack(alignment: .leading) {
                            HStack {
                                Spacer()
                                
                                Text("称号:")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                
                                Text(profile.alias ?? "さすらいの遅刻者")
                                    .foregroundColor(.white)
                                    .font(.system(size: 25))
                                    .bold()
                                
                                Spacer()
                                
                                Button(action: {
                                    withAnimation {
                                        isDrawerOpen.toggle()
                                    }
                                }) {
                                    Image(systemName: "gear")
                                        .foregroundColor(.white)
                                        .font(.system(size: 25))
                                }
                                
                                Spacer()
                            }
                            .padding(.bottom, 4)
                            
                            Rectangle()
                                .frame(height: 2)
                                .padding(.horizontal, 40)
                                .foregroundColor(.white)
                        }
                        VStack(spacing: 15) {
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 15) {
                                    HStack {
                                        AuthProfileImage()
                                        Text("名前: \(profile.name)")
                                            .font(.title3)
                                        Image(systemName: "pencil")
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 15) {
                                        HStack {
                                            Image(systemName: "clock.fill")
                                            Text("遅刻回数: \(profile.lateCount)")
                                                .font(.title2)
                                        }
                                        
                                        HStack {
                                            Image(systemName: "hand.raised.fill")
                                            Text("間に合った回数: \(profile.onTimeCount)")
                                                .font(.title2)
                                        }
                                        
                                        HStack {
                                            Image(systemName: "hourglass.bottomhalf.fill")
                                            Text("総遅刻時間: \(formatLateTime(totalLateTime: profile.totalLateTime))")
                                                .font(.title2)
                                        }
                                        Spacer()
                                    }
                                    .padding(.leading, 8)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .padding(.horizontal)
                            Spacer()
                        }
                        .padding(.top, 20)
                    }
                    .background(Color.green)
                    
                    Spacer()
                }
                
                if isDrawerOpen {
                    VStack {
                        GeometryReader { geometry in
                            ZStack(alignment: .trailing) {
                                Color.black.opacity(isDrawerOpen ? 0.4 : 0)
                                    .onTapGesture {
                                        withAnimation {
                                            isDrawerOpen.toggle()
                                        }
                                    }
                                
                                VStack(alignment: .leading, spacing: 30) {
                                    Spacer()
                                    
                                    Button(action: {
                                        showSignOutConfirmation = true
                                    }) {
                                        Text("サインアウト")
                                            .foregroundColor(.red)
                                            .font(.title3)
                                    }
                                    Button(action: {
                                        print("ユーザ名変更ボタンが押されました")
                                    }) {
                                        Text("ユーザ名変更")
                                            .foregroundColor(.black)
                                            .font(.title3)
                                    }
                                    
                                    Toggle(isOn: $isNotificationsEnabled) {
                                        Text("通知")
                                            .font(.title3)
                                    }
                                    
                                    Toggle(isOn: $isLocationEnabled) {
                                        Text("位置情報")
                                            .font(.title3)
                                    }
                                    
                                    Spacer()
                                }
                                .frame(width: geometry.size.width * 0.6)
                                .padding()
                                .background(Color.white)
                            }
                            .edgesIgnoringSafeArea(.top)
                        }
                        Spacer()
                    }
                    .transition(.move(edge: .trailing))
                }
            }
            .alert(isPresented: $showSignOutConfirmation) {
                Alert(
                    title: Text("サインアウト"),
                    message: Text("本当にサインアウトしますか？"),
                    primaryButton: .destructive(Text("サインアウト")) {
                        //viewModel.signOut() //TODO: 実験してみる
                    },
                    secondaryButton: .cancel(Text("キャンセル"))
                )
            }
        } else {
            VStack {
                Spacer()
                ProgressView("プロフィールを読み込み中...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .green))
                    .scaleEffect(1.5)
                Spacer()
            }
        }
    }
    
    func formatLateTime(totalLateTime: Int) -> String {
        let hours = totalLateTime / 60
        let minutes = totalLateTime % 60
        return "\(hours)h \(minutes)m"
    }
}
