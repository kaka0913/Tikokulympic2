import SwiftUI

struct MeetingTimeInformation: View {

    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 377, height: 30)
                .foregroundColor(.lightgray)
                .cornerRadius(15)
                .padding(.bottom)
            HStack {
                Text("集合時間")
                    .font(.title2)
                    .padding(.bottom)

                Text("10:00")
                    .font(.title2)
                    .padding(.bottom)
            }
        }
    }
}
