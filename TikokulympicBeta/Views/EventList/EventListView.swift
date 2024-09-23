//
//  EventListView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/07.
//

import SwiftUI

struct EventListView: View {
    @StateObject var viewModel: EventListViewModel = mock
    @State private var showingVoteAlert = false
    @State private var selectedStatus: ParticipationStatus?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TopBar()
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        EventDetailsSection(event: viewModel.event)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("連絡事項")
                                .font(.system(size: 15))
                                .bold()
                            Text(viewModel.event.message)
                                .font(.system(size: 15))
                        }
                        .padding(.horizontal, 8)
                        
                        Rectangle()
                            .fill(Color.blue)
                            .frame(height: 1)
                            .padding(.horizontal, 5)
                        
                        ParticipationStatusSection(participants: viewModel.participants)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding()
                }
                .background(ThemeColor.customBlue)
                
                BottomBar(onVote: {
                    showingVoteAlert = true
                })
                
                Spacer()
            }
            .alert("参加状況を選択", isPresented: $showingVoteAlert) {
                Button("参加") { selectedStatus = .participating }
                Button("不参加") { selectedStatus = .notParticipating }
                Button("途中参加") { selectedStatus = .partialParticipation }
                Button("キャンセル", role: .cancel) { }
            }
        }
    }
}

let mock = EventListViewModel(
    event:
    Event(
    title: "秋プロFB",
    description: "秋プロの成果を発表してもらいます！",
    isAllDay: false,
    startTime: Date(),
    endTime: Date().addingTimeInterval(3600 * 3),
    closingTime: Date().addingTimeInterval(3600 * 24 * 7),
    locationName: "立命館大学OIC",
    cost: 0,
    message: "以下のリンクにアクセスして事前アンケートに回答してください。\nURL: http://...",
    managerId: 1,
    latitude: "34.8241",
    longitude: "135.5174",
    options: []
),
participants: [
    Participant(name: "山田太郎", status: .participating),
    Participant(name: "佐藤花子", status: .participating),
    Participant(name: "鈴木一郎", status: .notParticipating),
    Participant(name: "田中美咲", status: .partialParticipation)
])

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventListView(viewModel: mock)
    }
}

