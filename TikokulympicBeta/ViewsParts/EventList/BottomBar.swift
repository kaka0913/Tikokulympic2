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
            
            NavigationLink(destination: Text("前のイベント"), tag: -1, selection: $currentEventIndex) {
                Image(systemName: "arrowtriangle.backward.fill")
                    .resizable()
                    .frame(width: 15, height: 30)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button("投票する", action: onVote)
                .padding(.horizontal, 50)
                .padding(.vertical, 12)
                .background(accentBlue)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.leading, 30)
                .padding(.trailing, 30)
            
            Spacer()
            
            NavigationLink(destination: Text("次のイベント"), tag: 1, selection: $currentEventIndex) {
                Image(systemName: "arrowtriangle.right.fill")
                    .resizable()
                    .frame(width: 15, height: 30)
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding()
    }
    
}

#Preview {
    BottomBar(onVote: {
        print("Vote button tapped")
    })
}

