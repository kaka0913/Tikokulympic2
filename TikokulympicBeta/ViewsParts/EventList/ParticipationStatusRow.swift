//
//  ParticipationStatusRow.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/23.
//

import SwiftUI

struct ParticipationStatusRow: View {
    let status: ParticipationStatus
    let participants: [Participant]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 4)
                    .padding(.trailing, 4)
                
                Text("\(status.rawValue): ")
                    .foregroundColor(.black)
                    .font(.system(size: 15))
                
                Text("\(participants.filter { $0.status == status }.count)人")
                    .font(.system(size: 15))
                    .foregroundColor(.blue)
            }
            
            ForEach(participants) { participant in
                
                HStack {
                    
                    Text(String(participant.name.prefix(1)))
                        .font(.caption)
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .padding(.trailing, 10)
                    
                    Text(participant.name)
                        .font(.caption)
                    
                }
                .padding(.vertical, 5)
            }
        }
    }
}

#Preview {
    ParticipationStatusRow(status: .notParticipating, participants: par)
}

let par = [
    Participant(name: "山田太郎", status: .participating),
    Participant(name: "佐藤花子", status: .participating),
    Participant(name: "鈴木一郎", status: .participating),
    Participant(name: "田中美咲", status: .partialParticipation)
]
