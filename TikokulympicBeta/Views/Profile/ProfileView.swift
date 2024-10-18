//
//  ProfileView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/07.
//
import SwiftUI

struct ProfileView: View {
    @Environment(\.userProfileModel) var userProfileModel

    var body: some View {
        VStack {
            if let profile = userProfileModel.profile {
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
    }
    
    func formatLateTime(totalLateTime: Int) -> String {
        let hours = totalLateTime / 60
        let minutes = totalLateTime % 60
        return "\(hours)h \(minutes)m"
    }
}




struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
