//
//  MeetingInfoView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/25.
//

import SwiftUI

struct MeetingInfoView: View {
    @AppStorage("start_time") var startTime: String = ""
    @AppStorage("location") var location: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            EventTimeRow(value: formattedMeetingTime)
            LocationRow(value: location)
        }
    }
    
    private var formattedMeetingTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = formatter.date(from: startTime) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "HH:mm"
            return outputFormatter.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
}

struct EventTimeRow: View {
    let value: String
    var imageName: String?
    
    var body: some View {
        ZStack() {
            Rectangle()
                .frame(width: 377, height: 30)
                .foregroundColor(.white)
                .cornerRadius(15)
                .padding(.bottom)
            HStack {
                Text("集合時間         ")
                    .font(.title2)
                    .bold()
                    .padding(.bottom)

                Text(value)
                    .font(.title2)
                    .bold()
                    .padding(.bottom)
            }
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 0)
        .cornerRadius(10)
    }
}

struct LocationRow: View {
    let value: String
    var imageName: String?
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 377, height: 30)
                .foregroundColor(.white)
                .cornerRadius(15)
                .padding(.bottom)
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .padding(.bottom)
                    
                Text(value)
                    .font(.title2)
                    .bold()
                    .padding(.bottom)
            }
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 0)
        .cornerRadius(10)
    }
}
