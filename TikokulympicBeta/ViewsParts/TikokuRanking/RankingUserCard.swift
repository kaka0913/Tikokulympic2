import SwiftUI


struct RankingUserCard: View {
    let user: UserRankingData
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                if ( user.rank == 1 ) {
                        ThemeColor.orange
                            .frame(width: 320, height: 80)
                        Color.lightgray
                            .frame(width: 70, height: 80)
                    
                }
                else if (user.rank == 2) {
                    ThemeColor.orange
                        .frame(width: 250, height: 80)
                    Color.lightgray
                        .frame(width: 140, height: 80)
                    
                }
                else if (user.rank == 3) {
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
                    RankBadge(rank: user.rank)
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


