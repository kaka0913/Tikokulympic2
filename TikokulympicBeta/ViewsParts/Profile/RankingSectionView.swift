//
//  RankingSectionView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/11/09.
//

import Foundation
import SwiftUI

struct RankingSectionView<T: RankingParticipant>: View {
    let title: String
    let rankings: [T]
    let valueFormatter: (T) -> String

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.title3)
                    .lineLimit(1)
                    .foregroundColor(ThemeColor.customGray)
                
                Spacer()
                
                Rectangle()
                    .fill(Color.green)
                    .frame(width: 200, height: 1)
                    .padding(.horizontal, 5)
            }
            
            ForEach(rankings.prefix(3)) { participant in
                HStack {
                    if( participant.position == 1) {
                        ZStack {
                            Image("ExplosionYellow")
                                .resizable()
                                .frame(width: 40, height: 40)
                            Text("1st")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.black)
                        }
                    }
                    else if( participant.position == 2) {
                        ZStack {
                            Image("RedBomb")
                                .resizable()
                                .frame(width: 40, height: 40)
                            Text("2nd")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    else if( participant.position == 3) {
                        ZStack {
                            Image("BlackBomb")
                                .resizable()
                                .frame(width: 40, height: 40)
                            Text("3rd")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Text(String(participant.name.prefix(1))) //TODO: プロフィール画像に置き換える
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 25, height: 25)
                        .background(Color.blue)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(participant.name)
                            .font(.title3)
                        Text("\(participant.alias)")
                            .font(.caption)
                    }
                    .foregroundColor(ThemeColor.customGray)

                    
                    Spacer()
                    
                    Text(valueFormatter(participant))
                        .font(.title3)
                        .padding(.trailing, 10)
                        .foregroundColor(ThemeColor.customGray)

                }
                .padding(.vertical, 10)
            }
        }
        .padding(.top, 30)
    }
}
