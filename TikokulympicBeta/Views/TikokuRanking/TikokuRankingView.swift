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
            HeaderView()
            
            TabSelectionView(selectedTab: $selectedTab)
                .padding(.top, -5)
            
            if selectedTab == 1 {
                if viewModel.isTikokulympicFinished {
                    Text("今回の遅刻リンピックは終了しました")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                } else {
                    RankingListView(userRankings: viewModel.userRankings)
                        .padding(.top, -15)
                }
            } else {
                Text("到着者リスト")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            viewModel.requestLatestRanking()
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

