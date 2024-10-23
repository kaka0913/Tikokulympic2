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
    let buttonAction: () async -> Void
    @State var shoingVoteAlert: Bool = false
    @State private var showingDeleteAlert = false

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        
                        ZStack(alignment: .trailing) {

                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(Color.blue)
                                    .padding(.trailing, 30)
                                    .padding(.leading, 70)
                            }
                            .alert(isPresented: $showingDeleteAlert) {
                                Alert(
                                    title: Text("確認"),
                                    message: Text("このイベントを削除してもいいですか？"),
                                    primaryButton: .destructive(Text("はい")) {
                                        Task {
                                            await buttonAction()
                                        }
                                        showingDeleteAlert = false
                                    },
                                    secondaryButton: .cancel(Text("キャンセル"))
                                        {
                                        showingDeleteAlert = false
                                        }
                                )
                            }

                            VStack(spacing: 0) {
                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(height: 5)
                                    .padding(.horizontal, 80)

                                HStack(spacing: 0) {

                                    Text(event.title)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color.blue)
                                }
                                .padding(.vertical, 10)

                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(height: 1)
                                    .padding(.horizontal, 5)
                            }
                        }

                        HStack {
                            Spacer()
                            
                            Text(event.description)
                                .font(.subheadline)
                            .foregroundColor(ThemeColor.customBlue)
                            
                            Spacer()
                        }
                        .padding(.vertical, 5)
                        
                        HStack {
                            Spacer()
                            
                            Text("参加投票締切: ")
                                .foregroundColor(.red) +
                            Text("\(formatDate(event.endDateTime))")
                                .bold()
                                .foregroundColor(.red)
                            
                            Spacer()
                        }
                        .font(.system(size: 15))
                        
                        EventInfoRow(icon: "person.fill", text: event.author?.authorName ?? "")
                        
                        EventInfoRow(icon: "calendar", text: formatDateRange(start: event.startDateTime, end: event.endDateTime))

                        EventInfoRow(icon: "mappin.and.ellipse", text: event.locationName)
                        
                        EventInfoRow(icon: "yensign.circle", text: "\(event.cost)円")
                        VStack(alignment: .leading) {
                            Text("連絡事項")
                                .font(.system(size: 15))
                                .bold()
                            Text(event.message)
                                .font(.system(size: 15))
                        }
                        .padding(.leading, 20)
                    }

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
    
    private func formatDateRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return "\(formatter.string(from: start)) ～ \(formatter.string(from: end))"
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "MM/dd(EEE) HH:mm"
        return formatter.string(from: date)
    }
}
