//
//  TikokuRankingView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/22.
//
import CoreLocation
import SwiftUI

struct TikokuRankingView: View {
    @StateObject private var viewModel = TikokuRankingViewModel()
    @State private var selectedTab: Int = 1
    @State private var showAlert: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(totalParticipants: viewModel.userRankings.count + viewModel.arrivalRankings.count, arrivals: viewModel.userRankings.count)
            
            TabSelectionView(selectedTab: $selectedTab)
                .padding(.top, -5)
            
            if selectedTab == 1 {
                if viewModel.isTikokulympicFinished {
                    Text("今回の遅刻リンピックは終了しました")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                } else if viewModel.userRankings.isEmpty {
                    Text("データがありません")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                } else {
                    RankingListView(userRankings: viewModel.userRankings)
                        .padding(.top, -15)
                }
                
            } else {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                } else if viewModel.arrivalRankings.isEmpty {
                    Text("まだ到着者がいません")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                } else {
                    ArrivalRankingListView(arrivals: viewModel.arrivalRankings)
                        .padding(.top, -15)
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            viewModel.requestLatestRanking()
            Task {
                await viewModel.getArrivalRanking(eventid: 37) //TODO: 適切なeventidを使用
            }
        }
        .onChange(of: selectedTab) { oldTab, newTab in
            if newTab == 0 {
                Task {
                    await viewModel.getArrivalRanking(eventid: 37) //TODO: 適切なeventidを使用
                }
            }
        }
        .onReceive(viewModel.$isTikokulympicFinished) { isFinished in
            if isFinished {
                showAlert = true
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("遅刻リンピック終了"), message: Text( "遅刻リンピックは終了しました"), dismissButton: .default(Text("OK")))
        }
    }
}

struct RankingListView: View {
    let userRankings: [UserRankingData]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(userRankings) { user in
                    RankingUserCard(user: user)
                }
            }
            .padding()
        }
    }
}

struct ArrivalRankingListView: View {
    let arrivals: [ArrivalUserData]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(arrivals) { user in
                    ArrivalUserCard(user: user)
                }
            }
            .padding()
        }
    }
}
