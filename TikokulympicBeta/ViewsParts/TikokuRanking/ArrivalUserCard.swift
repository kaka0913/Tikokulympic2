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
            HStack(spacing: 0) {
                if ( user.arrivalTime <= 0) {
                        ThemeColor.customGreen
                            .frame(width: 390, height: 80)
                }
                else if (( user.arrivalTime >= 0 ) && (user.arrivalTime <= 10)) {
                    ThemeColor.customYellow
                        .frame(width: 390, height: 80)
                }
                else if (user.arrivalTime >= 10) {
                    ThemeColor.orange
                        .frame(width: 390, height: 80)
                }
            }
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 5)
            
            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("\(user.position)st")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top, 10)
                        .frame(width: 80, height: 80)
                    
                    ProfileImageView(userid: String(user.id))
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(user.name)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.leading, 20)
                        Text("〜\(user.alias ?? "さすらいの")〜")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.leading, 20)
                    }
                    .padding(.trailing, -30)
                }
                .frame(width: 240, height: 80)
                .padding(.leading, -30)
                
                
                Text(user.arrivalTime > 0 ? "\(user.arrivalTime)分遅れ" : "\(-user.arrivalTime)分前行動")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 30)
                    .padding(.leading, 30)
            }
            .cornerRadius(15)
        }
    }
}
