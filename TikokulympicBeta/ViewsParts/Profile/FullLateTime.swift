import SwiftUI

struct FullLateTime: View {
    let totalLateTime = "1h20m"
    var body: some View {
        HStack {
            Image(systemName: "hourglass.bottomhalf.fill")
            Text("総遅刻時間: \(totalLateTime)")
                .font(.title2)
        }
    }
}
