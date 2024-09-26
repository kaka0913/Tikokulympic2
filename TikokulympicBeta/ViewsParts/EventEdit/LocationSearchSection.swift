//
//  LocationSearchSection.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/26.
//

import SwiftUI

struct LocationSearchSection: View {
    @Binding var searchQuery: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("地点登録")
                .font(.system(size: 15))
                .bold()
            TextField("検索...", text: $searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}
