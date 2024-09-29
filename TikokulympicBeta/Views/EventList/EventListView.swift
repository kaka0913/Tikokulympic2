//
//  EventListView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/07.
//

import SwiftUI

struct EventListView: View {
    @StateObject var viewModel: EventListViewModel = EventListViewModel()
    @State private var showingVoteAlert = false
    @State private var selectedStatus: ParticipationStatus?
    
    var body: some View {
        ScrollView(.horizontal) {
            GeometryReader { geo in
                ForEach(viewModel.events) { event in
                    HStack {
                        EventDetailsSection(event: event)
                            .frame(height: geo.size.height)
                    }
                }
            }
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

