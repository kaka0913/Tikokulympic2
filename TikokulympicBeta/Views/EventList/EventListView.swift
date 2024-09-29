//
//  EventListView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/07.
//

import SwiftUI

struct EventListView: View {
    @StateObject var viewModel = MockViewModelInfo()
    @State private var showingVoteAlert = false
    @State private var selectedStatus: ParticipationStatus?
    
    var body: some View {
        GeometryReader { proxy in
            NavigationStack {
                VStack(spacing: 0) {
                    TopBar()
                            ForEach(viewModel.events) { event in
                                ScrollView {
                                    EventListCard(event: event)
                                        .frame(width: proxy.size.width * 0.9, height: proxy.size.height * 0.9)
                                }
                            }

                        BottomBar(onVote: {
                            self.showingVoteAlert = true
                        })
                    
                    Spacer()
                    
                    .alert("参加状況を選択", isPresented: $showingVoteAlert) {
                        Button("参加") {  }
                        Button("不参加") { }
                        Button("途中参加") { }
                        Button("キャンセル", role: .cancel) { }
                    }
                }
                .background(ThemeColor.customBlue)
                .frame(alignment: .center)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .background(ThemeColor.customBlue)
        }
    }
}



//let mock = EventListViewModel(
//    event:
//    Event(
//        auther: Auther(autherId: 1, autherName: "しゅうと"),
//        title: "秋プロFB",
//    description: "秋プロの成果を発表してもらいます！",
//    isAllDay: false,
//    startTime: Date(),
//    endTime: Date().addingTimeInterval(3600 * 3),
//    closingTime: Date().addingTimeInterval(3600 * 24 * 7),
//    locationName: "立命館大学OIC",
//    cost: 0,
//    message: "以下のリンクにアクセスして事前アンケートに回答してください。\nURL: http://...",
//    managerId: 1,
//    latitude: "34.8241",
//    longitude: "135.5174",
//    options: []
//),
//participants: [
//    Participant(name: "山田太郎", status: .participating),
//    Participant(name: "佐藤花子", status: .participating),
//    Participant(name: "鈴木一郎", status: .notParticipating),
//    Participant(name: "田中美咲", status: .partialParticipation)
//])
//
//struct EventListView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventListView(viewModel: mock)
//    }
//}

