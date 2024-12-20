//
//  EventListView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/07.
//

import SwiftUI

struct EventListView: View {
    @StateObject var viewModel = EventListViewModel()
    @State private var showingVoteAlert = false
    @State private var selectedStatus: ParticipationStatus?
    @State private var currentIndex: Int = 0

    var body: some View {
        GeometryReader { proxy in
            NavigationStack {
                VStack(spacing: 0) {
                    if viewModel.isLoading {
                        VStack {
                            Spacer()
                            ProgressView("読み込み中...")
                                .scaleEffect(1.5, anchor: .center)
                                .frame(width: proxy.size.width, height: proxy.size.height)
                            Spacer()
                        }
                        .background(.white)
                        Spacer()
                    } else {
                        TopBar()
                        TabView(selection: $currentIndex) {
                            ForEach(viewModel.events.indices, id: \.self) { index in
                                ScrollView {
                                    EventListCard(event: viewModel.events[index], buttonAction: {
                                        await viewModel.deleteEvent(eventid: viewModel.events[index].id)
                                        await viewModel.getEvents()
                                    })
                                        .frame(
                                            width: proxy.size.width * 0.95,
                                            height: proxy.size.height * 0.9
                                        )
                                        .padding(.bottom, 30)
                                        .padding(.trailing, 30)
                                        .tag(index) // タグをインデックスに設定
                                }
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .indexViewStyle(.page(backgroundDisplayMode: .always)) // ページインジケーターの表示

                        HStack {
                            Button(action: {
                                withAnimation {
                                    currentIndex = (currentIndex - 1 + viewModel.events.count) % viewModel.events.count
                                }
                            }) {
                                Image(systemName: "arrowtriangle.backward.fill")
                                    .resizable()
                                    .frame(width: 15, height: 30)
                                    .foregroundColor(.white)
                            }

                            Button("投票する") {
                                showingVoteAlert = true
                            }
                            .padding(.horizontal, 50)
                            .padding(.vertical, 12)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .padding(.leading, 30)
                            .padding(.trailing, 30)

                            Button(action: {
                                withAnimation {
                                    currentIndex = (currentIndex + 1) % viewModel.events.count
                                }
                            }) {
                                Image(systemName: "arrowtriangle.right.fill")
                                    .resizable()
                                    .frame(width: 15, height: 30)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.vertical, 10)

                        Spacer()
                    }
                }
                .alert("参加状況を選択", isPresented: $showingVoteAlert) {
                    // 現在表示中のイベントのevent_idを取得
                    let currentEventID = viewModel.events.indices.contains(currentIndex) ? viewModel.events[currentIndex].id : 0
                    
                    Button("参加") {
                        Task {
                            await viewModel.putVote(eventid: currentEventID, option: "参加")
                        }
                    }
                    Button("不参加") {
                        Task {
                            await viewModel.putVote(eventid: currentEventID, option: "不参加")
                        }
                    }
                    Button("途中から参加") {
                        Task {
                            await viewModel.putVote(eventid: currentEventID, option: "途中から参加")
                        }
                    }
                    Button("キャンセル", role: .cancel) {}
                }
                .background(ThemeColor.customBlue)
                .frame(alignment: .center)

                Spacer()
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .background(ThemeColor.customBlue)
        }
        .onAppear {
            Task {
                await viewModel.getEvents()
            }
        }
    }
}

