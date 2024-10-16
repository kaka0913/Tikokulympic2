//
//  EventHeader.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/24.
//

import SwiftUI

struct EventHeader: View {
    let title: String
    
    var body: some View {
        ZStack(alignment: .trailing) {

            Button(action: {
                //TODO: 処理を記述
            }) {
                Image(systemName: "ellipsis")
                    .foregroundColor(Color.blue)
                    .padding(.trailing, 30)
                    .padding(.leading, 70)
            }

            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.blue)
                    .frame(height: 5)
                    .padding(.horizontal, 80)

                HStack(spacing: 0) {

                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.blue)
                }
                .padding(.vertical, 10)

                Rectangle()
                    .fill(Color.blue)
                    .frame(height: 1)
                    .padding(.horizontal, 5)
            }
        }
    }
}

