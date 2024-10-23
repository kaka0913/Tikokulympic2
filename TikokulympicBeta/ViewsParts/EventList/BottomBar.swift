//
//  BottomBar.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/23.
//

import SwiftUI

struct BottomBar: View {
    @State private var currentEventIndex: Int = 0
    let onVote: () -> Void
    let totalEvents: Int
    
    var body: some View {
        HStack {
            Spacer()
            
            eventNavigationButton(direction: .backward, isDisabled: currentEventIndex <= 0) {
                currentEventIndex = max(0, currentEventIndex - 1)
            }
            
            Spacer()
            
            Button("投票する", action: onVote)
                .padding(.horizontal, 50)
                .padding(.vertical, 12)
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.leading, 30)
                .padding(.trailing, 30)
            
            Spacer()
            
            eventNavigationButton(direction: .forward, isDisabled: currentEventIndex >= totalEvents - 1) {
                currentEventIndex = min(totalEvents - 1, currentEventIndex + 1)
            }
            
            Spacer()
        }
        .padding()
        .background(ThemeColor.customBlue)
        .navigationTitle("イベント \(currentEventIndex + 1)")
    }
    
    private func eventNavigationButton(direction: Direction, isDisabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: direction == .backward ? "arrowtriangle.backward.fill" : "arrowtriangle.right.fill")
                .resizable()
                .frame(width: 15, height: 30)
                .foregroundColor(.white)
        }
        .disabled(isDisabled)
    }
    
    enum Direction {
        case backward, forward
    }
}
