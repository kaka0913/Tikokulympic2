import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack(spacing: 20) {
            Title()
            
            VStack(spacing: 20) {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        UserName()
                        UserInformation()
                    }
                    Spacer()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .padding(.horizontal)
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .background(Color.green)
        .cornerRadius(20)
        .padding(.all, 10)
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
