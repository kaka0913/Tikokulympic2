import GoogleSignIn
import GoogleSignInSwift
import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        VStack {
            Image("TikokuGorin")
                .resizable()
                .scaledToFit()
            
//            Image("TigerLine")
//                .resizable()
//                .scaledToFit()
//                .padding(.top,100)
//            Image("Tikokuou2")
//                .resizable()
//                .scaledToFit()
//            Image("TigerLine")
//                .resizable()
//                .scaledToFit()
            if viewModel.isSignedIn {
                Text("Signed in successfully!")
                    .font(.title)
                    .padding()
            } else {
                Text("Sign in with Google")
                    .font(.title)
                    .padding()

                GoogleSignInButton {
                    viewModel.signInWithGoogle()
                }
                .frame(width: 220, height: 50)
                .padding()
            }
        }
    }
}

struct GoogleSignInView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
