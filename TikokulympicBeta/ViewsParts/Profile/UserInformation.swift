import SwiftUI
let lateCount = 2
let onTimeCount = 0
let totalLateTime = "1h20m"

struct UserInformation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "clock.fill")
                Text("遅刻回数: \(lateCount)")
                    .font(.title2)
            }
            
            HStack {
                Image(systemName: "hand.raised.fill")
                Text("間に合った回数: \(onTimeCount)")
                    .font(.title2)
            }
            
            HStack {
                Image(systemName: "hourglass.bottomhalf.fill")
                Text("総遅刻時間: \(totalLateTime)")
                    .font(.title2)
            }
            Spacer()
        }
    }
}

#Preview {
    UserInformation()
}
