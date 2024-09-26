//
//  TopBar.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/23.
//

import SwiftUI

struct TopBar: View {
    @State private var isNavigating = false
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            Text("イベント招集")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
                .padding(.leading, 100)
                .padding(.trailing, 40)
            Spacer()
            Button(action: {
                isNavigating = true
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(ThemeColor.customBlue)
                    .padding(8)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .navigationDestination(isPresented: $isNavigating) {
                EventEditView()
                .navigationBarBackButtonHidden(true)
            }
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
        }
        .background(ThemeColor.customBlue)
    }
}

#Preview {
    TopBar()
}

