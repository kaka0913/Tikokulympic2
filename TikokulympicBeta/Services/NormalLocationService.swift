//
//  NormalLocationService.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/20.
//

import Foundation
import Combine
import CoreLocation
import Supabase

@MainActor
class NormalLocationService: ObservableObject {
    @Published var latitude: Float = 0.0
    @Published var longitude: Float = 0.0
    
    let userid: Int
    
    private var cancellables = Set<AnyCancellable>()
    private let client = SupabaseClientManager.shared.client
    private var timer: Timer?
    
    init(userid: Int) async {
        self.userid = userid
        await fetchLocation()
        startTimer()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func fetchLocation() async {
        do {
            guard let client = self.client else {
                print("Supabase client is not available")
                return
            }
            
            let response = try await client
                .from("locations")
                .select("id, user_id, latitude, longitude")
                .eq("user_id", value: userid)
                .single()
                .execute()
            
            let decoder = JSONDecoder()
            let location = try decoder.decode(Location.self, from: response.data)
            
            await MainActor.run {
                self.latitude = location.latitude
                self.longitude = location.longitude
            }
                    
        } catch {
            print("Error fetching location: \(error)")
        }
    }
    
    private func postLocation() async {
        let userid = 112
        let latitude: Float = 14.23
        let logitude: Float = 16.23
        
        do {
            
            guard let client = self.client else {
                print("Supabase client is not available")
                return
            }
            
            let uuid = UUID()
            let hashValue = uuid.hashValue
            let intValue = abs(hashValue)
            
            let location = Location(id: intValue, user_id: userid, latitude: latitude, longitude: logitude)
            
            let response = try await client
                .from("locations")
                .insert(location)
                .execute()
            
        } catch {
            print("Error fetching location: \(error)")
        }
    }
    
    // Start a timer to update location every 10 seconds
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task {
                await self.fetchLocation()
                await self.postLocation()
            }
        }
    }
}
