//
//  EventEditViewModel.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/26.
//

import SwiftUI
import GooglePlaces

let key = "createdEventIds"
var savedIds = UserDefaults.standard.array(forKey: key) as? [Int] ?? []

class EventEditViewModel: ObservableObject {
    @Published var eventName = ""
    @Published var eventDescription = ""
    @Published var startDateTime = Date()
    @Published var endDateTime = Date()
    @Published var applicationDeadline = Date()
    @Published var locationName = ""
    @Published var pointName = ""
    @Published var fee = ""
    @Published var contactInfo = ""
    @Published var latitude  = 0.0
    @Published var longitude = 0.0
    @Published var autocompleteResults: [GMSAutocompletePrediction] = []

    let placesClient = GMSPlacesClient.shared()
 
    var isFormValid: Bool {
        return !eventName.isEmpty &&
               !eventDescription.isEmpty &&
               startDateTime < endDateTime &&
               !locationName.isEmpty &&
               !fee.isEmpty &&
               !contactInfo.isEmpty
    }
    
    func fetchPlaceDetails(placeID: String) {
        placesClient.lookUpPlaceID(placeID) { (place, error) in
            if let error = error {
                print("エラー: \(error.localizedDescription)")
                return
            }

            if let place = place {
                self.latitude = place.coordinate.latitude
                self.longitude = place.coordinate.longitude
                
                print("緯度: \(self.latitude), 経度: \(self.longitude)")
            }
        }
    }

    func fetchAutocompleteResults(input: String) {
        guard !input.isEmpty else {
            self.autocompleteResults.removeAll()
            return
        }

        let filter = GMSAutocompleteFilter()
        filter.type = .address
        filter.country = "JP"

        placesClient.findAutocompletePredictions(fromQuery: input, filter: filter, sessionToken: nil) { results, error in
            if let error = error {
                print("エラー: \(error.localizedDescription)")
                return
            }

            DispatchQueue.main.async {
                self.autocompleteResults = results ?? []
            }
        }
    }

    func completeEditing() async {
        guard Int(fee) != nil else {
            print("数字のみを入力してください")
            return
        }
        do {
            let response = try await EventService.shared.postNewEvent(
                title: eventName,
                description: eventDescription,
                isAllDay: false,
                startDateTime: startDateTime,
                endDateTime: endDateTime,
                closingDateTime: applicationDeadline,
                locationName: locationName,
                cost: Int(fee) ?? 0,
                message: contactInfo,
                latitude: self.latitude,
                longitude: self.longitude
            )
            self.addIdToUserDefaults(response.event_id)
            
        } catch {
            print("イベントの更新に失敗しました: \(error)")
        }
    }

    func addIdToUserDefaults(_ newId: Int) {
        savedIds.append(newId)
        UserDefaults.standard.set(savedIds, forKey: key)
    }
}
