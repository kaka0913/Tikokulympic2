//
//  ProfileView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/07.
//
import SwiftUI

struct ProfileView: View {
    @StateObject var vm = ProfileViewModel()
    
    // Mock data
    let lateCount = 2
    let onTimeCount = 0
    let totalLateTime = "1h20m"
    let title = "警察なのに遅刻"

    var body: some View {
            
        VStack {
            VStack(spacing: 0) {
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        
                        Text("称号:")
                            .foregroundColor(.white)
                            .font(.system(size: 20))

                        Text(title)
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

                                }

                                VStack(alignment: .leading, spacing: 15) {
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
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
