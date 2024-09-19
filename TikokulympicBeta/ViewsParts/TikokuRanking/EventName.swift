//
//  EventName.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/20.
//

import SwiftUI

struct EventName: View {
    var body: some View {
        @State() var Event: String="イベント名"
        ZStack{
            HStack(spacing: 0){
                Image("EventBack")
                    .resizable()
                
                    .frame(width: 268, height: 68)
                    
                Spacer()
            }
            HStack{
                Text(Event)
                    .font(.largeTitle)
                    .padding(.leading, 40)
                Spacer()
            }
            
                
        }
        
        
    }
}

#Preview {
    EventName()
}
