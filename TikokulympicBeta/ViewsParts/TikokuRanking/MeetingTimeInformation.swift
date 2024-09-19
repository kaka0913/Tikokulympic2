import SwiftUI
import Foundation

struct MeetingTimeInformation: View {
    let calendar = Calendar.current
    var meetingTime: Date {
        var components = calendar.dateComponents([.year, .month, .day,.hour, .minute], from: Date())
        components.year=2024
        components.month=9
        components.day=19
        components.hour = 19
        components.minute = 0
        return calendar.date(from: components) ?? Date()
    }

    // Date を "HH:mm" 形式にフォーマット
    var formattedMeetingTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: meetingTime)
    }

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

                Text(formattedMeetingTime)  // ここでフォーマットされた時間を表示
                    .font(.title2)
                    .padding(.bottom)
            }
        }
    }
}
