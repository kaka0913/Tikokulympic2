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

        let managerId = 1
        let latitude = "35.6895"
        let longitude = "139.6917"

        let newEvent = Event(
            title: eventName,
            description: eventDescription,
            isAllDay: false,
            startTime: startDateTime,
            endTime: endDateTime,
            closingTime: applicationDeadline,
            locationName: location,
            cost: cost,
            message: contactInfo,
            managerId: managerId,
            latitude: latitude,
            longitude: longitude,
            options: options
        )

        await EventService.shared.postNewEvent(event: newEvent)
    }
}
