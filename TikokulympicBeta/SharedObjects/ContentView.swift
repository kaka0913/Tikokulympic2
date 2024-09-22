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

            AuthView()  //時間の都合上作成できなかった画面の位置に一旦認証画面を差し込んでいる
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("掲示板")
                }

            ProfileImageView()
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
