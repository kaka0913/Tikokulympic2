//
//  InputField.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/26.
//

import SwiftUI

struct InputField: View {
    let title: String
    let placeholder: String?
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 15))
                .bold()
            TextField(placeholder ?? "", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(keyboardType)
        }
    }
}
