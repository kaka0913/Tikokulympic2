//
//  TikokuRankingService.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/17.
//

import Alamofire
import Foundation

struct BaseMessage: Decodable {
    let action: String
}

struct TikokulympicFinishedMessage: Decodable {
    let action: String
    let message: String
}

class TikokuRankingService: NSObject, WebSocketClientDelegate {
    static let shared = TikokuRankingService()
    private override init() {
        super.init()
        WebSocketClient.shared.delegate = self
    }
    
    private var messageContinuation: AsyncStream<TikokuRankingMessage>.Continuation?
    
    func messageStream() -> AsyncStream<TikokuRankingMessage> {
        return AsyncStream { continuation in
            self.messageContinuation = continuation
            
            //ストリームが終了した際にこれ以上メッセージが流れないようにする処理
            continuation.onTermination = { @Sendable _ in
                self.messageContinuation = nil
            }
            
        }
    }
    
    // 最新のランキングをリクエストするメソッド
    func requestLatestRanking() {
        let messageDict: [String: Any] = ["action": "get_ranking"]
        if let jsonData = try? JSONSerialization.data(withJSONObject: messageDict),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            WebSocketClient.shared.sendMessage(jsonString) { success in
                if success {
                    print("最新のランキングをリクエストしました")
                } else {
                    print("ランキングのリクエストに失敗しました")
                }
            }
        }
    }
    
    func didReceiveMessage(_ text: String) {
        // 受信したメッセージをパース
        if let data = text.data(using: .utf8) {
            do {
                let decoder = JSONDecoder()
                let baseMessage = try decoder.decode(BaseMessage.self, from: data)
                switch baseMessage.action {
                case "ranking_update":
                    // ランキング更新メッセージを処理
                    let rankingUpdate = try decoder.decode(RankingUpdateMessage.self, from: data)
                    messageContinuation?.yield(.rankingUpdate(rankingUpdate.ranking))
                case "tikokulympic_finished":
                    // 遅刻リンピック終了メッセージを処理
                    let finishedMessage = try decoder.decode(TikokulympicFinishedMessage.self, from: data)
                    messageContinuation?.yield(.tikokulympicFinished(finishedMessage.message))
                    // ストリームを終了
                    messageContinuation?.finish()
                default:
                    print("未知のアクション: \(baseMessage.action)")
                }
            } catch {
                print("メッセージのパースに失敗しました: \(error)")
            }
        } else {
            print("テキストをデータに変換できませんでした")
        }
    }
}
