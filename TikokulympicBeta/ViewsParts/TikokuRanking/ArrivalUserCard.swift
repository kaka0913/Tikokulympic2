//
//  ArrivalUserCard.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/10/23.
//

import SwiftUI

struct ArrivalUserCard: View {
    let user: ArrivalUserData
    
    var body: some View {
        ZStack {
            Group {
                if user.arrivalTime <= 0 {
                    ThemeColor.customGreen.opacity(0.7)
                } else if user.arrivalTime <= 10 {
                    ThemeColor.customYellow.opacity(0.7)
                } else {
                    ThemeColor.orange.opacity(0.7)
                }
            }
            .frame(height: 80)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 5)

            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("\(user.position)st")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                        .frame(width: 35)
                        .padding(.leading, -25)

                    ProfileImageView(userid: String(user.id))
                        .frame(width: 50, height: 50)
                        .padding(.horizontal, 10)

                    VStack(alignment: .leading, spacing: 10) {
                        Text(user.name)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .lineLimit(1)

                        Text("〜\(user.alias ?? "さすらい")〜")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                            .lineLimit(1)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                Spacer()

                HStack {
                    Text(user.arrivalTime > 0 ? "\(user.arrivalTime)" : "\(-user.arrivalTime)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                    Text(user.arrivalTime > 0 ? "分遅れ" : "分前行動")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top, 8)
                }
                .padding(.trailing, -5)
            }
            .padding(.horizontal)
        }
        .frame(height: 80)
    }
}
