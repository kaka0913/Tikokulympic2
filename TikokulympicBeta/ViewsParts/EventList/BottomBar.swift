//
//  BottomBar.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/23.
//

import SwiftUI

struct BottomBar: View {
    @State private var currentEventIndex: Int? = 0
    let onVote: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: {
                //TODO: ここに前のイベントに遷移する処理を書く
            }) {
                Image(systemName: "arrowtriangle.backward.fill")
                    .resizable()
                    .frame(width: 15, height: 30)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button("投票する", action: onVote)
                .padding(.horizontal, 50)
                .padding(.vertical, 12)
                .background(ThemeColor.accentBlue)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.leading, 30)
                .padding(.trailing, 30)
            
            Spacer()
            
            Button(action: {
                //TODO: ここに次のイベントに遷移する処理を書く
            }) {
                Image(systemName: "arrowtriangle.right.fill")
                    .resizable()
                    .frame(width: 15, height: 30)
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding()
        .background(ThemeColor.customBlue)
        
        .navigationDestination(isPresented: Binding(
            get: { currentEventIndex == -1 },
            set: { if !$0 { currentEventIndex = nil } }
        )) {
            Text("前のイベント")
        }
        
        .navigationDestination(isPresented: Binding(
            get: { currentEventIndex == 1 },
            set: { if !$0 { currentEventIndex = nil } }
        )) {
            Text("次のイベント")
        }
    }
}

#Preview {
    BottomBar(onVote: {
        print("Vote button tapped")
    })
}

