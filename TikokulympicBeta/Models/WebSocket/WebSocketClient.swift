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
        print("WebSocket connecting...")
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
                self.handleConnectionError()
                
            case .success(let message):
                
                switch message {
                    
                case .string(let text):
                    print("Received text: \(text)")
                    self.delegate?.didReceiveMessage(text)
                    
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        print("Received data: \(text)")
                        self.delegate?.didReceiveMessage(text)
                    } else {
                        print("Received binary data that couldn't be decoded.")
                    }
                    
                @unknown default:
                    print("Received unknown message format.")
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
            print("Retrying connection in \(delay) seconds...")
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.connect()
            }
        } else {
            print("Max reconnect attempts reached.")
        }
    }
}

protocol WebSocketClientDelegate: AnyObject {
    func didReceiveMessage(_ text: String)
}

extension WebSocketClient: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("WebSocket connected successfully")
        isConnected = true
        reconnectAttempts = 0
        receiveMessage() // メッセージ受信を開始
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("WebSocket error: \(error.localizedDescription)")
            isConnected = false
            handleConnectionError()
        } else {
            print("WebSocket closed successfully")
            isConnected = false
        }
    }
}
