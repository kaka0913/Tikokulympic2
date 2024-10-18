//
//  TikokuRankingViewModel.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/20.
//

import CoreLocation
import UIKit
import SwiftUI

class TikokuRankingViewModel: ObservableObject {
    @Published var userRankings: [UserRankingData] = []
    @Published var isTikokulympicFinished: Bool = false
    private var rankingService = TikokuRankingService.shared
    private var messageTask: Task<Void, Never>?
    private var rankingRequestTask: Task<Void, Never>?

    init() {
        messageTask = Task {
            await listenForMessages()
        }
    }
    
    deinit {
        messageTask?.cancel()
    }
    
    func requestLatestRanking() {
        rankingRequestTask?.cancel() // 既存のタスクがあればキャンセル
        rankingRequestTask = Task {
            // WebSocketの接続が確立されるまで待機
            while !WebSocketClient.shared.isConnected {
                try? await Task.sleep(nanoseconds: 100_000_000) // 100ミリ秒待機
            }
            // 接続が確立されたら最新のランキングをリクエスト
            rankingService.requestLatestRanking()
        }
    }

    private func listenForMessages() async {
        let messageStream = rankingService.messageStream()
        for await message in messageStream {
            switch message {
            case .rankingUpdate(let rankings):
                DispatchQueue.main.async {
                    self.userRankings = rankings
                }
            case .tikokulympicFinished(let message):
                DispatchQueue.main.async {
                    self.isTikokulympicFinished = true
                }
                // ループを抜けてタスクを終了
                break
            }
        }
        // ストリームが終了したため WebSocket を切断
        WebSocketClient.shared.disconnect()
    }
}
