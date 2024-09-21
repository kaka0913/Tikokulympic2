import CoreLocation
import SwiftUI

struct TikokuRankingView: View {
    @State var timerHandler: Timer?
    @State private var selectedIndex: Int = 0
    @StateObject private var viewModel = LimitTimeViewPropertyFactory()
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .frame(height: 355)
                    .foregroundColor(.darkred)
                VStack {
                    EventName()
                    LimitTime(limitTime: $viewModel.remainingTime)
                    MeetingTimeInformation()
                    LocationInformation()
                }
            }
            .padding(.bottom)

            TextSegmentedControl()

            RankingUserCardSet()
        }
    }
}

#Preview {
    TikokuRankingView()
}
