//
//  NameEdit.swift
//  TikokulympicBeta
//
//  Created by 牟禮優汰 on 2024/10/01.
//

import SwiftUI

struct NameEdit: View {
    @State private var userName: String = "ニックネーム"
    @State private var isEditing: Bool = false

    var body: some View {
        HStack {
            if isEditing {
                TextField("名前を入力", text: $userName)
                    .font(.title3)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                Text("名前: \(userName)")
                    .font(.title3)
            }

            Button(action: {
                isEditing.toggle()
            }) {
                Image(systemName: "pencil")
            }
        }
        .padding()
    }
}

#Preview {
    NameEdit()
}

