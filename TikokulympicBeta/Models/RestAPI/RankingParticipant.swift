//
//  RankingParticipant.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/11/09.
//

import Foundation

protocol RankingParticipant: Identifiable {
    var id: Int { get }
    var position: Int { get }
    var name: String { get }
    var alias: String { get }
}
