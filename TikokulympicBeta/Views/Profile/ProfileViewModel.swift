//
//  ProfileViewModel.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/22.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfileResponse?
    private let userProfileService = UserProfileService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Task {
            await fetchProfile()
        }
    }
    
    @MainActor
    func fetchProfile() async {
        do {
            let profile = try await userProfileService.getProfile()
            self.profile = profile
            print("プロフィールの取得に成功しました")
            print("profile: \(String(describing: self.profile))")
        } catch {
            print("プロフィールの取得に失敗しました: \(error)")
        }
    }
}
