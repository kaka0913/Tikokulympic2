//
//  EventListCard.swift
//  TikokulympicBeta
//
//  Created by 澤木柊斗 on 2024/09/26.
//




import Foundation
import SwiftUI

struct EventListCard: View {
    let event: Event
    @State var shoingVoteAlert: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 16) {
                ScrollView {
                    EventDetailsSection(event: event)
                    
                    Rectangle()
                        .fill(Color.blue)
                        .frame(height: 1)
                        .padding(.horizontal, 5)
                    
                    ParticipationStatusSection(participants: event.options.participants)
                    
                }
            }
            .frame(width: proxy.size.width * 0.9, height: proxy.size.height)
            .background(Color.white)
            .cornerRadius(20)
            .padding()
        }
    }
}







