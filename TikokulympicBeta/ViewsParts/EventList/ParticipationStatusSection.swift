//
//  ParticipationStatusSection.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/23.
//

import SwiftUI

struct ParticipationStatusSection: View {
    let participants: [Participant]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("参加状況")
                .font(.system(size: 15))
                .bold()
            
            ForEach(ParticipationStatus.allCases, id: \.self) { status in
                ParticipationStatusRow(status: status, participants: participants.filter { $0.status == status
                }
                )
            }
        }
    }
}
