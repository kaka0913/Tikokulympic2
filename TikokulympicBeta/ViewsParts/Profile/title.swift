//
//  Title.swift
//  TikokulympicBeta
//
//  Created by 牟禮優汰 on 2024/09/23.
//

import SwiftUI

struct Title: View {
    let title = "警察なのに遅刻"
    var body: some View {
        HStack {
            
            Text("称号")
                .foregroundColor(.white)
                .font(.headline)
                .padding(.trailing, 8)
            
            Text(title)
                .foregroundColor(.white)
                .font(.headline)
        }
        .padding(.top, 16)
    }
}

