//
//  EventEditViewModel.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/26.
//

import SwiftUI

class EventEditViewModel: ObservableObject {
    @Published var eventName = ""
    @Published var eventDescription = ""
    @Published var applicationDeadline = Date()
    @Published var startDateTime = Date()
    @Published var endDateTime = Date()
    @Published var location = ""
    @Published var fee = ""
    @Published var contactInfo = ""
    @Published var locationSearchQuery = ""
    
    var isFormValid: Bool {
        return !eventName.isEmpty &&
               !eventDescription.isEmpty &&
               startDateTime < endDateTime &&
               !location.isEmpty &&
               !fee.isEmpty &&
               !contactInfo.isEmpty
    }
    
    func completeEditing() {
        // 編集完了の処理を実装
    }
}
