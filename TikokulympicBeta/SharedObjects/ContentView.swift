//
//  ContentView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/03.
//

import SwiftUI

struct ContentView: View {
    @State var userProfileModel = UserProfileModel()

    var body: some View {
        TabView {
            TikokuRankingView()
                .tabItem {
                    Image(systemName: "house.fill")
                        .background(ThemeColor.vividRed)
                    Text("ランキング")
                }

            EventListView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                        .background(ThemeColor.accentBlue)
                    Text("掲示板")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "gear")
                        .background(ThemeColor.customGreen)
                    Text("プロフィール")
                }
                .environment(userProfileModel)
            
        }
    }
}

#Preview {
    ContentView()
}
