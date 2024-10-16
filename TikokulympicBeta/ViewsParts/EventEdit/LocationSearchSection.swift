import SwiftUI

struct LocationSearchSection: View {
    @State private var predictions: [String] = []
    @Binding var searchQuery: String
    private let apiKey = "API key"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("地点登録")
                .font(.system(size: 15))
                .bold()
            
            TextField("検索...", text: $searchQuery, onEditingChanged: { _ in }, onCommit: {
                self.performSearch()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .onChange(of: searchQuery) {
                self.performSearch()
            }

            
            if !predictions.isEmpty {
                List(predictions, id: \.self) { prediction in
                    Text(prediction)
                }
                .frame(maxHeight: 150)
            }
        }
    }
    func performSearch() {
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(searchQuery)&key=\(apiKey)&types=(cities)") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }

            do {
                let result = try JSONDecoder().decode(PlaceAutocompleteResponse.self, from: data)
                DispatchQueue.main.async {
                    self.predictions = result.predictions.map { $0.description }
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    }



