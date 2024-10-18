//
//  EventDetailSection.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/23.
//

import SwiftUI

struct EventDetailsSection: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            EventHeader(title: event.title)

            HStack {
                Spacer()
                
                Text(event.description)
                    .font(.subheadline)
                .foregroundColor(ThemeColor.customBlue)
                
                Spacer()
            }
            .padding(.vertical, 5)
            
            HStack {
                Spacer()
                
                Text("参加投票締切: ")
                    .foregroundColor(.red) +
                Text("\(formatDate(event.endDateTime))")
                    .bold()
                    .foregroundColor(.red)
                
                Spacer()
            }
            .font(.system(size: 15))
            
            EventInfoRow(icon: "person.fill", text: event.author?.authorName ?? "ななし")
            
            EventInfoRow(icon: "calendar", text: formatDateRange(start: event.startDateTime, end: event.endDateTime))

            EventInfoRow(icon: "mappin.and.ellipse", text: event.locationName)
            
            EventInfoRow(icon: "yensign.circle", text: "\(event.cost)円")
            VStack(alignment: .leading) {
                Text("連絡事項")
                    .font(.system(size: 15))
                    .bold()
                Text(event.message)
                    .font(.system(size: 15))
            }
            .padding(.leading, 20)
        }
    }
    
    private func formatDateRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return "\(formatter.string(from: start)) ～ \(formatter.string(from: end))"
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "MM/dd(EEE) HH:mm"
        return formatter.string(from: date)
    }
}
