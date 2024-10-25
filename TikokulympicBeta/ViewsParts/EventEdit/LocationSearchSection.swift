    import SwiftUI
    import GooglePlaces

struct LocationSearchSection: View {
    @Binding  var searchText: String
    @Binding var autocompleteResults: [GMSAutocompletePrediction]
    var placesClient = GMSPlacesClient.shared()

    var body: some View {
        VStack {

            TextField("場所を入力してください", text: $searchText, onEditingChanged: { isEditing in
                if !isEditing {
                    autocompleteResults.removeAll()
                }
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .onChange(of: searchText) { newValue in
                fetchAutocompleteResults(input: newValue)
            }


            
        }
    }

    // 自動補完候補を取得するメソッド
    func fetchAutocompleteResults(input: String) {
        guard !input.isEmpty else {
            autocompleteResults.removeAll()
            return
        }

        let filter = GMSAutocompleteFilter()
        filter.type = .address
        filter.country = "JP"

        placesClient.findAutocompletePredictions(fromQuery: input, filter: filter, sessionToken: nil) { results, error in
            if let error = error {
                print("エラー: (error.localizedDescription)")
                return
            }

            DispatchQueue.main.async {
                print((results as! [GMSAutocompletePrediction]).map{$0.attributedPrimaryText.string} )
                self.autocompleteResults = results ?? []
            }
        }
    }
}
