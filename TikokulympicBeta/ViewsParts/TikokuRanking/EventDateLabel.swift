//
//  EventDateLabel.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/25.
//

import SwiftUI

struct EventDateLabel: View {
    let title: Date

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: title)
    }
    
    struct SlantedShape: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.maxX, y: 0))
            path.addLine(to: CGPoint(x: rect.maxX - 20, y: rect.maxY))
            path.addLine(to: CGPoint(x: 0, y: rect.maxY))
            path.closeSubpath()
            return path
        }
    }
    
    var body: some View {
            VStack {
                ZStack(alignment: .topLeading) {
                    Color.white
                        .clipShape(SlantedShape())

                    Text(formattedDate)
                        .font(.system(size: 25, weight: .bold, design: .default))
                        .foregroundColor(.black)
                        .padding([.top, .leading], 5)
                }
                .frame(width: 220, height: 40)
                .overlay(
                    GeometryReader { geometry in
                        Path { path in
                            let width = geometry.size.width
                            let height = geometry.size.height
                            path.move(to: CGPoint(x: width + 10, y: 0))
                            path.addLine(to: CGPoint(x: width - 10, y: height))
                        }
                        .stroke(Color.white, lineWidth: 2)
                    }
                )
                .padding(.trailing, 180)
                .padding(.top, 15)
            }
        }
}
