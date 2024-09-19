import SwiftUI
struct RankingUserCardSet: View {
    var body: some View {
        
        List(sortedUserCards.enumerated().map({ $1 })) { userCard in
            RankingUserCard(
                name: userCard.name,
                title: userCard.title,
                distance: userCard.distance,
                currentLocation: userCard.currentLocation,
                rankState: userCard.rankState
            )
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
        }
    }
    
    var sortedUserCards: [RankingUserCard] {
        // distanceの数値に基づいて降順で並べ替え
        var sorted = userCards.sorted {
            guard let distance1 = Double($0.distance), let distance2 = Double($1.distance) else {
                return false
            }
            return distance1 > distance2
        }
        
        // 順番に基づいてrankStateを適用
        for (index, _) in sorted.enumerated() {
            switch index {
            case 0:
                sorted[index].rankState = .first
            case 1:
                sorted[index].rankState = .secound
            case 2:
                sorted[index].rankState = .third
            default:
                sorted[index].rankState = .normal
            }
        }
        
        return sorted
    }
}
