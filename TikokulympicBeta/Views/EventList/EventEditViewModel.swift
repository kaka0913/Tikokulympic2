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
    @Published var startDateTime = Date()
    @Published var endDateTime = Date()
    @Published var applicationDeadline = Date()
    @Published var location = ""
    @Published var fee = ""
    @Published var contactInfo = ""
    @Published var locationSearchQuery = ""
    let options: [Option] = []

    var isFormValid: Bool {
        return !eventName.isEmpty &&
               !eventDescription.isEmpty &&
               startDateTime < endDateTime &&
               !location.isEmpty &&
               !fee.isEmpty &&
               !contactInfo.isEmpty
    }

    func completeEditing() async {
        guard let cost = Int(fee) else {
            print("数字のみを入力してください")
            return
        }

        let userid = UserDefaults.standard.integer(forKey: "userid")
        let latitude = "34.8108" //TODO: 位置検索から緯度経度を取得して渡す
        let longitude = "135.5612"
        
        let newEvent = Event(
            id: 1, //TODO: 修正
            author: nil,
            title: eventName,
            description: eventDescription,
            isAllDay: false,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            closingDateTime: applicationDeadline,
            locationName: location,
            latitude: 35.00,
            longitude: 36.00,
            cost: Int(fee) ?? 0,
            message: contactInfo,
            options: options
        )

        await EventService.shared.postNewEvent(event: newEvent)
    }
}
