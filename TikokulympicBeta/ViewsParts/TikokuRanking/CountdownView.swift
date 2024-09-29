//
//  CountdownView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/25.
//

import SwiftUI

struct CountdownView: View {
    @AppStorage("start_time") var startTime: String = ""
    @State private var remainingTime: TimeInterval = 0
    
    var body: some View {
        VStack(spacing: 0) {
            Text(formattedTime)
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 300)
                .monospacedDigit()
                .multilineTextAlignment(.center)
        }
        .padding(.top, -10)
        .onAppear(perform: startCountdown)
    }
    
    private var formattedTime: String {
        let hours = Int(remainingTime) / 3600
        let minutes = (Int(remainingTime) % 3600) / 60
        let seconds = Int(remainingTime) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func startCountdown() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        // startTimeが有効な日時かチェック
        guard let startDate = formatter.date(from: startTime), startDate > Date() else {
            remainingTime = 0
            return
        }
        
        // Timerを設定してカウントダウンを実行
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            let currentTime = Date()
            remainingTime = startDate.timeIntervalSince(currentTime)
            
            if remainingTime <= 0 {
                remainingTime = 0
                timer.invalidate() // カウントダウン終了
            }
        }
    }
}


#Preview {
    CountdownView()
}
