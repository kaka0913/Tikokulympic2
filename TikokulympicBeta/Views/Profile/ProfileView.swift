//
//  ProfileView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/07.
//
import SwiftUI

struct ProfileView: View {
    @StateObject var vm = ProfileViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            if let profile = vm.profile {
                HStack {
                    Text("称号")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.trailing, 8)
                    
                    Text(profile.alias)
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .padding(.top, 16)
                
                VStack(spacing: 20) {
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                Text("名前: \(profile.name)")
                                    .font(.title3)
                                Image(systemName: "pencil")
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "clock.fill")
                                    Text("遅刻回数: \(profile.late_count)")
                                        .font(.title2)
                                }
                                
                                HStack {
                                    Image(systemName: "hand.raised.fill")
                                    Text("間に合った回数: \(profile.on_time_count)")
                                        .font(.title2)
                                }
                                
                                HStack {
                                    Image(systemName: "hourglass.bottomhalf.fill")
                                    Text("総遅刻時間: \(profile.total_late_time)")
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
            } else {
                // Loading state
                ProgressView("プロフィールを読み込み中...")
                    .padding()
            }
            
            Spacer()
        }
        .background(Color.green)
        .cornerRadius(20)
        .padding(.all, 10)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
