//
//  WebSocketClient.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/10/14.
//

import Foundation

class WebSocketClient : NSObject {
    static let shared = WebSocketClient()
    private var webSocketTask: URLSessionWebSocketTask?
    var isConnected = false
    private var reconnectAttempts = 0
    private let maxReconnectAttempts = 5
    private var reconnectDelay: TimeInterval = 2.0 // 再接続の遅延時間
    weak var delegate: WebSocketClientDelegate?
    
    private override init() {
        super.init()
    }
    
    func connect() {
        guard !isConnected else { return }
        let url = URL(string: "wss://watnow-hack2024.onrender.com/ws/ranking")!
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        print("WebSocketに接続中...")
    }
    
    func disconnect() {
        isConnected = false
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        webSocketTask = nil
        print("WebSocket接続が切断されました")
    }
    
    func sendMessage(_ message: String, completion: @escaping (Bool) -> Void) {
        guard isConnected else {
            print("WebSocketが接続されていません。")
            completion(false)
            return
        }
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("WebSocketメッセージ送信エラー: \(error)")
                completion(false)
            } else {
                print("メッセージ送信完了: \(message)")
                completion(true)
            }
        }
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            switch result {
                
            case .failure(let error):
                print("WebSocketメッセージ受信エラー: \(error)")
                self.isConnected = false
                self.handleConnectionError()
                
            case .success(let message):
                
                switch message {
                    
                case .string(let text):
                    print("受信したテキストメッセージ: \(text)")
                    self.delegate?.didReceiveMessage(text)
                    
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        print("受信したデータメッセージ: \(text)")
                        self.delegate?.didReceiveMessage(text)
                    } else {
                        print("受信したバイナリデータをデコードできませんでした。")
                    }
                    
                @unknown default:
                    print("受信した不明なメッセージ形式。")
                }
                // 次のメッセージを受け取る
                self.receiveMessage()
            }
        }
    }
    
    private func handleConnectionError() {
        isConnected = false
        reconnectAttempts += 1
        if reconnectAttempts <= maxReconnectAttempts {
            let delay = reconnectDelay * Double(reconnectAttempts)
            print("接続再試行中... \(delay) 秒後に再接続を試みます")
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.connect()
            }
        } else {
            print("再接続の最大試行回数に達しました。")
        }
    }
}

extension WebSocketClient: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("WebSocket接続が正常に確立されました")
        isConnected = true
        reconnectAttempts = 0
        receiveMessage() // メッセージ受信を開始
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("WebSocketエラー: \(error.localizedDescription)")
            isConnected = false
            handleConnectionError()
        } else {
            print("WebSocket接続が正常に終了しました")
            isConnected = false
        }
    }
}

protocol WebSocketClientDelegate: AnyObject {
    func didReceiveMessage(_ text: String)
}
