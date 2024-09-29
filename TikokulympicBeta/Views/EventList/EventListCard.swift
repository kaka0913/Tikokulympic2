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
    @Binding var shoingVoteAlert: Bool

    var body: some View {
        NavigationStack{
            VStack(spacing: 0) {
                TopBar()
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        EventDetailsSection(event: event)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("連絡事項")
                                .font(.system(size: 15))
                                .bold()
                            Text(event.message)
                                .font(.system(size: 15))
                        }
                        .padding(.horizontal, 8)

                        Rectangle()
                            .fill(Color.blue)
                            .frame(height: 1)
                            .padding(.horizontal, 5)

                        ParticipationStatusSection(participants: event.options.participants)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding()
                }
                .background(ThemeColor.customBlue)

                BottomBar(onVote: {
                    self.shoingVoteAlert = true
                })

                Spacer()
            }
            .alert("参加状況を選択", isPresented: $shoingVoteAlert) {
                Button("参加") {  }
                Button("不参加") { }
                Button("途中参加") { }
                Button("キャンセル", role: .cancel) { }
            }
        }
    }
}
