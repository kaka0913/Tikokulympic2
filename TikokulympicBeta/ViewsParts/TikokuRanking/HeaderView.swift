//
//  HeaderView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/25.
//

import SwiftUI

struct HeaderView: View {
    @AppStorage("title") var title: String = ""
    let totalParticipants: Int
    let arrivals: Int?
    
    var body: some View {
        VStack(spacing: 10) {
            EventDateLabel()
            
            ZStack {
                VStack(spacing: 0) {
                    Color.black
                }
                MarqueeText(
                    text: "参加者数：\(totalParticipants)人　到着者数：\(arrivals ?? 0)人",
                    font: .system(size: 20, weight: .bold),
                    speed: 5
                )
                .frame(height: 35)
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

struct MarqueeText: View {
    let text: String
    let font: Font
    let speed: Double


    @State private var textWidth: CGFloat = 0
    @State private var containerWidth: CGFloat = 0
    @State private var offsetX: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let animation = Animation.linear(duration: speed).repeatForever(autoreverses: false)

            
            VStack {
                Spacer()
                Text(text)
                Spacer()
            }
                .font(font)
                .foregroundColor(.yellow)
                .background(WidthPreferenceSetter())
                .offset(x: offsetX)
                .onAppear {
                    containerWidth = geo.size.width
                    offsetX = containerWidth
                    withAnimation(animation) {
                        offsetX = -textWidth
                    }
                }
                .onPreferenceChange(WidthPreferenceKey.self) { value in
                    textWidth = value
                }
        }
        .clipped()
    }
}

// テキストの幅を取得するための PreferenceKey
struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// テキストの幅を測定するためのバックグラウンドビュー
struct WidthPreferenceSetter: View {
    var body: some View {
        GeometryReader { geo in
            Color.clear.preference(key: WidthPreferenceKey.self, value: geo.size.width)
        }
    }
}
