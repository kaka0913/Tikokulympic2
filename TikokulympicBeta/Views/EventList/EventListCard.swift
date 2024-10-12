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
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    EventDetailsSection(event: event)

                    Rectangle()
                        .fill(Color.blue)
                        .frame(height: 1)
                        .padding(.horizontal, 5)

                    ParticipationStatusSection(options: event.options ?? [Option(title: "参加", participantCount: 11, participants: Participants(participants: nil, status: nil))])
                        .padding(.leading, 20)
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .background(Color.white)
            .cornerRadius(20)
            .padding()
        }
    }
}







