//
//  ProfileView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/07.
//
import SwiftUI

struct ProfileView: View {
    // Mock data
    let userName = "あああ"
    let lateCount = 2
    let onTimeCount = 0
    let totalLateTime = "1h20m"
    let title = "警察なのに遅刻"
    
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
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
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
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
