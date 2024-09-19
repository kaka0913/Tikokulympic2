//
//  RealTimeLocationService.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/19.
//

import Foundation
import Supabase


class RealTimeDataBaseService {
    
    let client: SupabaseClient
    var channel: RealtimeChannelV2?
    
    init() async {
        // Initialize the client
        self.client = SupabaseClientManager.shared.client! //**TODO: 修正**
        
        // Initialize the channel
        self.channel = client.realtimeV2.channel("locations")
        
        // Set up event listeners
        setupEventListeners()
        
        // Subscribe to the channel
        await subscribeToChannel()
    }
    
    private func setUpChannel() async {
        setupEventListeners()
        await subscribeToChannel()
    }
    
    private func setupEventListeners() {
        client.realtime.channel("realtime:public:locations")
            .delegateOn("UPDATE", filter: ChannelFilter(event: nil, schema: nil, table: nil, filter: nil), to: self) { a, b in
                print("通知を検知しました")
            }
    }
    
    private func subscribeToChannel() async {
        await channel?.subscribe()
    }
}



//    private func subscribeToChannel(completion: @escaping (RealtimeChannelV2?) -> Void) {
//        channel?.subscribe { [weak self] result in
//            switch result {
//            case .ok:
//                print("Successfully subscribed to locations")
//                completion(self?.channel)
//            case .error(let error):
//                print("Failed to subscribe to locations: \(error)")
//                completion(nil)
//            }
//        }

