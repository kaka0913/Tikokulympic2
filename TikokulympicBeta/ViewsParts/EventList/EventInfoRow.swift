//
//  EventInfoRow.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/23.
//

import SwiftUI

struct EventInfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(text)
                .padding(.leading, 30)
        }
        .font(.subheadline)
        .padding(.vertical, 5)
        .padding(.leading, 15)
    }
}
