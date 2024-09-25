//
//  CountdownView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/25.
//

import SwiftUI

struct CountdownView: View {
    let targetTime: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    
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
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            let currentTime = Date()
            remainingTime = targetTime.timeIntervalSince(currentTime)
            
            if remainingTime <= 0 {
                remainingTime = 0
                timer.invalidate()
            }
        }
    }
}


#Preview {
    CountdownView()
}
