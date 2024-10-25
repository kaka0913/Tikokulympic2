//
//  EventEditViewModel.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/26.
//

import SwiftUI
import GooglePlaces

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
    @Published var latitude  = 0.0
    @Published var longitude = 0.0
    let options: [Option] = []
    let placesClient = GMSPlacesClient.shared()
 
    var isFormValid: Bool {
        return !eventName.isEmpty &&
               !eventDescription.isEmpty &&
               startDateTime < endDateTime &&
               !location.isEmpty &&
               !fee.isEmpty &&
               !contactInfo.isEmpty
    }
 func fetchPlaceDetails(placeID: String) {
            placesClient.lookUpPlaceID(placeID) { (place, error) in
                if let error = error {
                    print("エラー: (error.localizedDescription)")
                    return
                }

                if let place = place {
                    self.latitude = place.coordinate.latitude
                    self.longitude = place.coordinate.longitude
                    
                    print("緯度: \(self.latitude), 経度: \(self.longitude)")
                }
            }
        }


    func completeEditing() async {
        guard let cost = Int(fee) else {
            print("数字のみを入力してください")
            return
        }

        let userid = UserDefaults.standard.integer(forKey: "userid")
        
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
            latitude: self.latitude,
            longitude: self.longitude,
            cost: Int(fee) ?? 0,
            message: contactInfo,
            options: options
        )

        await EventService.shared.postNewEvent(event: newEvent)
    }
}
