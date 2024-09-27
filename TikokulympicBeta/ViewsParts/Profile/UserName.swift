import SwiftUI

let userName = "あああ"

struct UserName: View {
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            Text("名前: \(userName)")
                .font(.title3)
            Image(systemName: "pencil")
        }
    }
}

#Preview {
    UserName()
}
