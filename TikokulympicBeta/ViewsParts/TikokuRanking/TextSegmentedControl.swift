//
//  TextSegmentedControl.swift
//  TikokulympicBeta
//
//  Created by 牟禮優汰 on 2024/09/19.
//

import SwiftUI

struct TextSegmentedControl: View {
    @State private var selectedIndex: Int = 0

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<2) { index in
                Text(index == 0 ? "到着者" : "ランキング")
                    .font(index == 0 ? .system(size: 24) : .system(size: 24))
                    .fontWeight(.bold)
                    .frame(width: 115)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .background(self.selectedIndex == index ? Color.darkred : Color.lightgray)
                    .foregroundColor(self.selectedIndex == index ? Color.white : Color.black)
                    .clipShape(
                        index == 0
                            ? RoundedCornerShape(corners: [.topLeft, .bottomLeft], radius: 40)
                            : RoundedCornerShape(corners: [.topRight, .bottomRight], radius: 40)
                    )
                    .onTapGesture {
                        self.selectedIndex = index
                    }
            }
        }
    }
}

struct RoundedCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect, byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    TextSegmentedControl()
}
