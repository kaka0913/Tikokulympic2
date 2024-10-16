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
        isConnected = true
        print("WebSocket connected")
        receiveMessage()
    }
    
    func disconnect() {
        isConnected = false
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        webSocketTask = nil
        print("WebSocket disconnected")
    }
    
    func sendMessage(_ message: String, completion: @escaping (Bool) -> Void) {
        guard isConnected else {
            print("WebSocket is not connected.")
            completion(false)
            return
        }
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("WebSocket sending error: \(error)")
                completion(false)
            } else {
                print("Message sent: \(message)")
                completion(true)
            }
        }
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print("WebSocket receiving error: \(error)")
                self.isConnected = false
                //TODO: WebSocket接続は一度切れると、手動で再接続を試みる必要があるため、エラーで切断された場合に再接続を試みるロジックをここに実装
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received text: \(text)")
                    self.delegate?.didReceiveMessage(text)
                case .data(let data): //警告がでるのでバイナリ型のデータの場合を実装しておく
                    if let text = String(data: data, encoding: .utf8) {
                        print("Received data: \(text)")
                        self.delegate?.didReceiveMessage(text)
                    } else {
                        print("Received binary data that couldn't be decoded.")
                    }
                @unknown default:
                    print("Received unknown message format.")
                }
                // 次のメッセージを受け取り続けるために必要
                self.receiveMessage()
            }
        }
    }
}

protocol WebSocketClientDelegate: AnyObject {
    func didReceiveMessage(_ text: String)
}

extension WebSocketClient: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("WebSocket connected successfully")
        // 必要な初期処理を行う
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("WebSocket error: \(error)")
            // エラーハンドリングや再接続のロジックを実装する
        }
    }
}
