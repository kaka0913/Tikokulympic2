//
//  LoadingRankingView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/11/09.
//

import Foundation
import SwiftUI

struct LoadingRankingView: View {
    let title: String
    
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
            
            VStack {
                ProgressView("ランキングを読み込み中...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .green))
                    .padding()
            }
            .padding(.vertical, 10)
        }
        .padding(.top, 30)
    }
}
