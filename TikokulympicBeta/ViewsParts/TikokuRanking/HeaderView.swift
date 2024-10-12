//
//  HeaderView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/25.
//

import SwiftUI

struct HeaderView: View {
    @AppStorage("title") var title: String = ""
    let arrivals: Int = 13 //TODO: 配列から実際の人数を取得する
    
    var body: some View {
        VStack(spacing: 10) {
            EventDateLabel()
            
            ZStack {
                VStack(spacing: 0) {
                    Color.black
                }
                Text("～\(arrivals)人が到着完了！～")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(.yellow)
                    .padding(.horizontal, 10)
            }
            .frame(height: 35)
            .padding(.vertical, 15)
            .padding(.top, -10)
            
            Text(title)
                .font(.system(size: 24, weight: .bold, design: .default))
                .foregroundColor(.white)
                .padding(.top, -10)
            
            CountdownView()
            MeetingInfoView()
        }
        .padding(.top, 44)
        .padding(.bottom, 5)
        .background(ThemeColor.vividRed)
    }
}
