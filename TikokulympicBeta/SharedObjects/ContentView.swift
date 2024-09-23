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
                    Text("ランキング")
                }

            EventListView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("掲示板")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("プロフィール")
                }
                .environment(userProfileModel)
            
        }
        //AuthView()
    }
}

#Preview {
    ContentView()
}
