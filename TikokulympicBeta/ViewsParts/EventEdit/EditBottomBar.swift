//
//  EditBottomBar.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/26.
//

import SwiftUI

struct EditBottomBar: View {
    let cancelAction: () -> Void
    let completeAction: () -> Void
    var isFormValid: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            
            Button("キャンセル", action: cancelAction)
                .padding(.vertical, 12)
                .padding(.horizontal, 40)
                .background(Color.lightgray)
                .foregroundColor(.blue)
                .cornerRadius(20)
            
            Button("完了する", action: completeAction)
                .padding(.vertical, 12)
                .padding(.horizontal, 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
                .disabled(isFormValid)
            
        }
        .padding()
        .background(ThemeColor.customBlue)
    }
}
