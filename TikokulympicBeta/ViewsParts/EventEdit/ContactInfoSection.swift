//
//  ContactInfoSection.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/26.
//

import SwiftUI

struct ContactInfoSection: View {
    @Binding var message: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("連絡事項")
                .font(.system(size: 15))
                .bold()
            TextEditor(text: $message)
                .frame(height: 100)
                .padding(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.lightgray, lineWidth: 1)
                )
                .cornerRadius(8)

        }
    }
}
