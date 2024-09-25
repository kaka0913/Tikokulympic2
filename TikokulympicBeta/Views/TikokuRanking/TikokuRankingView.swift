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
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(viewModel: viewModel)
            
            TabSelectionView(selectedTab: $selectedTab)
                .padding(.top, -5)
            
            if selectedTab == 1 {
                RankingListView(userRankings: viewModel.userRankings)
                    .padding(.top, -15)
            } else {
                Text("到着者リスト")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
            }
        }
        .edgesIgnoringSafeArea(.top)
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

struct TikokuRankingView_Previews: PreviewProvider {
    static var previews: some View {
        TikokuRankingView()
    }
}

