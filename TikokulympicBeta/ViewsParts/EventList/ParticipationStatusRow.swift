//
//  ParticipationStatusRow.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/23.
//

import SwiftUI

struct ParticipationStatusRow: View {
    let option: Option
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 4)
                    .padding(.trailing, 4)
                
                Text("\(option.title): ")
                    .foregroundColor(.black)
                    .font(.system(size: 15))
                
                Text("\(option.participantCount)人")
                    .font(.system(size: 15))
                    .foregroundColor(.blue)
            }
            
            ForEach(option.participants?.participants ?? [Participant(userId: 1, name: "しゅうと")]) { participant in

                HStack {
                    
                    Text(String(participant.name!.prefix(1)))
                        .font(.caption)
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .padding(.trailing, 10)
                    
                    Text(participant.name ?? "ななし")
                        .font(.caption)
                    
                }
                .padding(.vertical, 5)
            }
        }
    }
}

