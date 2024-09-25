//
//  TabSelectionView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/25.
//

import SwiftUI

struct TabSelectionView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            TabButton(title: "到着者", isSelected: selectedTab == 0) {
                selectedTab = 0
            }
            TabButton(title: "ランキング", isSelected: selectedTab == 1) {
                selectedTab = 1
            }
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
        .padding()
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 24, weight: .bold, design: .default))
                .fontWeight(.bold)
                .foregroundColor(isSelected ? .white : .black)
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .background(isSelected ? ThemeColor.vividRed : Color.clear)
                .padding(.horizontal, 5)
                .padding(.vertical, 5)
                .cornerRadius(25)
        }
    }
}
