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
            
            if let participants = option.participants?.participants {
                ForEach(participants) { participant in
                    HStack {
                        if let userId = participant.userId {
                            ProfileImageView( userid: String(userId), FrameSize: 20)
                                .frame(width: 20, height: 20)
                        } else {
                            Text(String(participant.name?.prefix(1) ?? ""))
                                .font(.caption)
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .padding(.trailing, 10)
                        }
                        
                        Text(participant.name ?? "")
                            .font(.caption)
                    }
                    .padding(.vertical, 5)
                }
            } else {
                HStack {
                    Color.clear
                        .frame(width: 30, height: 20)
                        .padding(.trailing, 10)

                    Color.clear
                        .frame(width: 50, height: 20)
                }
                .padding(.vertical, 5)
            }

        }
    }
}

