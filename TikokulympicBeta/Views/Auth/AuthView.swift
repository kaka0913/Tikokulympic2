import GoogleSignIn
import GoogleSignInSwift
import SwiftUI


struct AuthView: View {

    var body: some View {
        NavigationStack {
            VStack {
                Image("TikokuGorin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 80)
                    .padding(.bottom, 200)

                NavigationLink(destination: SignUpView()) {
                    Text("新規登録")
                        .padding(.vertical, 12)
                        .padding(.horizontal, 45)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
                .padding(.bottom, 20)

                NavigationLink(destination: SignInView()) {
                    Text("ログイン")
                        .padding(.vertical, 12)
                        .padding(.horizontal, 45)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
