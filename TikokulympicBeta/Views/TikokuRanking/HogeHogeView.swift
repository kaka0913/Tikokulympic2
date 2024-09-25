//
//  HogeHogeView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/24.
//

import Foundation
import SwiftUI
import CoreLocation

// MARK: - Models

enum Rank: Int {
    case first = 1
    case second
    case third
    case normal
}

struct UserRankingData: Identifiable {
    let id = UUID()
    let name: String
    let title: String
    var distance: Double
    let currentLocation: CLLocation
    var rank: Rank = .normal
}

// MARK: - View Models

class TikokuRankingViewModel: ObservableObject {
    @Published var userRankings: [UserRankingData] = []
    @Published var remainingTime: TimeInterval = 0
    @Published var eventName: String = "イベント名"
    @Published var meetingTime: Date = Date()
    @Published var meetingLocation: String = "立命館大学"
    
    private var timer: Timer?
    private let locationManager = CLLocationManager()
    private let destinationLocation = CLLocation(latitude: 34.6937, longitude: 135.5023) // 大阪の座標
    
    init() {
        setupLocationManager()
        setupTimer()
        setupMockData()
    }
    
    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateRemainingTime()
        }
    }
    
    private func setupMockData() {
        userRankings = [
            UserRankingData(name: "しゅうと", title: "遅刻王", distance: 0, currentLocation: CLLocation(latitude: 35.6895, longitude: 139.6917)),
            UserRankingData(name: "かぶたん", title: "遅刻王", distance: 0, currentLocation: CLLocation(latitude: 34.6937, longitude: 135.5023)),
            UserRankingData(name: "ゆうた", title: "ねぼう王", distance: 0, currentLocation: CLLocation(latitude: 35.0116, longitude: 135.7681)),
            UserRankingData(name: "しょうま", title: "ねぼう王", distance: 0, currentLocation: CLLocation(latitude: 34.6851, longitude: 135.8050))
        ]
        updateDistances()
    }
    
    func updateDistances() {
        for i in 0..<userRankings.count {
            userRankings[i].distance = userRankings[i].currentLocation.distance(from: destinationLocation) / 1000
        }
        sortAndRankUsers()
    }
    
    private func sortAndRankUsers() {
        userRankings.sort { $0.distance > $1.distance }
        for (index, _) in userRankings.enumerated() {
            userRankings[index].rank = index < 3 ? Rank(rawValue: index + 1)! : .normal
        }
    }
    
    private func updateRemainingTime() {
        let currentDate = Date()
        remainingTime = max(meetingTime.timeIntervalSince(currentDate), 0)
    }
}

// MARK: - Views

struct TikokuRankingView: View {
    @StateObject private var viewModel = TikokuRankingViewModel()
    @State private var selectedTab: Int = 1 // 1 for Ranking, 0 for Arrived
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(viewModel: viewModel)
            
            TabSelectionView(selectedTab: $selectedTab)
                .padding(.top, -5)
            
            if selectedTab == 1 {
                RankingListView(userRankings: viewModel.userRankings)
                    .padding(.top, -15)
            } else {
                Text("到着者リスト")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

func createDate(from string: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    return formatter.date(from: string) ?? Date()
}

struct HeaderView: View {
    @ObservedObject var viewModel: TikokuRankingViewModel
    let date = createDate(from: "2024/09/20")
    
    var body: some View {
        VStack(spacing: 10) {
            EventDateLabel(title: date)
            
            ZStack {
                VStack(spacing: 0) {
                    Color.black
                }
                Text("～13人が到着完了！～")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(.yellow)
                    .padding(.horizontal, 10)
            }
            .frame(height: 35)
            .padding(.vertical, 15)
            .padding(.top, -10)
            
            Text(viewModel.eventName)
                .font(.system(size: 24, weight: .bold, design: .default))
                .foregroundColor(.white)
                .padding(.top, -10)
            
            CountdownView(remainingTime: viewModel.remainingTime)
            MeetingInfoView(meetingTime: viewModel.meetingTime, location: viewModel.meetingLocation)
        }
        .padding(.top, 44)
        .padding(.bottom, 5)
        .background(ThemeColor.vividRed)
    }
}

struct EventDateLabel: View {
    let title: Date

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: title)
    }
    
    var body: some View {
            VStack {
                ZStack(alignment: .topLeading) {
                    Color.white
                        .clipShape(SlantedShape()) // White slanted area

                    Text(formattedDate)
                        .font(.system(size: 25, weight: .bold, design: .default))
                        .foregroundColor(.black)
                        .padding([.top, .leading], 5)
                }
                .frame(width: 220, height: 40)
                .overlay(
                    // Add the reversed slanted line next to the white area
                    GeometryReader { geometry in
                        Path { path in
                            let width = geometry.size.width
                            let height = geometry.size.height
                            path.move(to: CGPoint(x: width + 10, y: 0))  // Start at the top-right corner
                            path.addLine(to: CGPoint(x: width - 10, y: height))  // Slanted line downwards to the left
                        }
                        .stroke(Color.white, lineWidth: 2)
                    }
                )
                .padding(.trailing, 180)
                .padding(.top, 15)
            }
        }
    }

struct SlantedShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX - 20, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct CountdownView: View {
    let remainingTime: TimeInterval
    
    var body: some View {
        VStack(spacing: 0) {
            Text(formattedTime)
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.top, -10)
    }
    
    private var formattedTime: String {
        let hours = Int(remainingTime) / 3600
        let minutes = (Int(remainingTime) % 3600) / 60
        let seconds = Int(remainingTime) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

struct MeetingInfoView: View {
    let meetingTime: Date
    let location: String
    
    var body: some View {
        VStack(spacing: 0) {
            EventTimeRow(value: formattedMeetingTime)
            LocationRow(value: location)
        }
    }
    
    private var formattedMeetingTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: meetingTime)
    }
}

struct EventTimeRow: View {
    let value: String
    var imageName: String?
    
    var body: some View {
        ZStack() {
            Rectangle()
                .frame(width: 377, height: 30)
                .foregroundColor(.white)
                .cornerRadius(15)
                .padding(.bottom)
            HStack {
                Text("集合時間         ")
                    .font(.title2)
                    .bold()
                    .padding(.bottom)

                Text(value)
                    .font(.title2)
                    .bold()
                    .padding(.bottom)
            }
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 0)
        .cornerRadius(10)
    }
}

struct LocationRow: View {
    let value: String
    var imageName: String?
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 377, height: 30)
                .foregroundColor(.white)
                .cornerRadius(15)
                .padding(.bottom)
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .padding(.bottom)
                    
                Text(value)
                    .font(.title2)
                    .bold()
                    .padding(.bottom)
            }
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 0)
        .cornerRadius(10)
    }
}

struct TabSelectionView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            TabButton(title: "到着者", isSelected: selectedTab == 0) {
                selectedTab = 0
            }
            TabButton(title: "ランキング", isSelected: selectedTab == 1) {
                selectedTab = 1
            }
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
        .padding()
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 24, weight: .bold, design: .default))
                .fontWeight(.bold)
                .foregroundColor(isSelected ? .white : .black)
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .background(isSelected ? ThemeColor.vividRed : Color.clear)
                .padding(.horizontal, 5)
                .padding(.vertical, 5)
                .cornerRadius(25)
        }
    }
}

struct RankingListView: View {
    let userRankings: [UserRankingData]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(userRankings) { user in
                    RankingUserCard(user: user)
                }
            }
            .padding()
        }
    }
}

struct RankingUserCard: View {
    let user: UserRankingData
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                if ( user.rank.rawValue == 1 ) {
                        ThemeColor.orange
                            .frame(width: 320, height: 80)
                        Color.lightgray
                            .frame(width: 70, height: 80)
                    
                }
                else if (user.rank.rawValue == 2) {
                    ThemeColor.orange
                        .frame(width: 250, height: 80)
                    Color.lightgray
                        .frame(width: 140, height: 80)
                    
                }
                else if (user.rank.rawValue == 3) {
                    ThemeColor.customYellow
                        .frame(width: 160, height: 80)
                    Color.lightgray
                        .frame(width: 230, height: 80)
                    
                } else {
                    ThemeColor.customGreen
                        .frame(width: 120, height: 80)
                    Color.lightgray
                        .frame(width: 270, height: 80)
                }

            }
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 5)
            
            HStack(spacing: 10) {
                
                HStack(spacing: 15) {
                    RankBadge(rank: user.rank.rawValue)
                        .frame(width: 80, height: 80)
                        .padding(.leading, -20)
                    
                    Image("Shoma") //TODO: 差し替え
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                        .padding(.leading, -10)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(user.name)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.leading, 20)
                        Text("〜\(user.title)〜")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.leading, 20)
                    }
                    .padding(.trailing, -40)
                }
                .frame(width: 240, height: 80)

                Spacer()

                Text("\(Int(user.distance))km")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 30)
                    .padding(.trailing, 10)
                    .frame(width: 130, height: 80)
            }
        }
    }
}

struct RankBadge: View {
    let rank: Int
    
    var body: some View {
        ZStack {
            if ( rank == 1 ) {
                Image("ExplosionYellow")
                    .resizable()
                    .frame(width: 90, height: 90)
                Text("\(rank)st")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.black)
                
            }
            else if (rank == 2) {
                Image("RedBomb")
                    .resizable()
                    .frame(width: 70, height: 80)
                Text("\(rank)st")
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 15)
                    .padding(.trailing, 5)
                
            }
            else if (rank == 3) {
                Image("BlackBomb")
                    .resizable()
                    .foregroundColor(Color.yellow)
                    .frame(width: 60, height: 70)
                Text("\(rank)st")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 15)
                
            } else {
                Image("")
                    .resizable()
                    .foregroundColor(Color.yellow)
                    .frame(width: 60, height: 60)
                Text("\(rank)st")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 10)
            }
        }
    }
}

// MARK: - Preview

struct TikokuRankingView_Previews: PreviewProvider {
    static var previews: some View {
        TikokuRankingView()
    }
}
