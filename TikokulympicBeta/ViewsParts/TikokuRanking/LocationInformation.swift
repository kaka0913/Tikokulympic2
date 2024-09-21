import SwiftUI

struct LocationInformation: View {
    var body: some View {
        @State var location: String = "立命館大学"
        ZStack {
            Rectangle()
                .frame(width: 377, height: 30)
                .foregroundColor(.lightgray)
                .cornerRadius(15)
                .padding(.bottom)
            HStack {
                Image("Location")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding(.bottom)
                Text(location)
                    .font(.title2)
                    .padding(.bottom)
            }
        }
    }
}
