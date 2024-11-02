import GoogleSignIn
import GoogleSignInSwift
import SwiftUI


struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                Image("TikokuGorin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 80)
                    .padding(.bottom, 40)

                VStack(alignment: .leading, spacing: 5) {
                    TextField("メールアドレスを入力", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    if let emailError = viewModel.emailError {
                        Text(emailError)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)

                VStack(alignment: .leading, spacing: 5) {
                    SecureField("パスワードを入力", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    if let passwordError = viewModel.passwordError {
                        Text(passwordError)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)

                Button(action: {
                    if viewModel.validateEmail(), viewModel.validatePassword() {
                        Task {
                            await viewModel.signUp()
                        }
                    }
                }) {
                    Text("新規登録")
                        .padding(.vertical, 12)
                        .padding(.horizontal, 45)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
                .padding(.bottom, 20)
                .navigationDestination(isPresented: $viewModel.isSignUpSuccess) {
                    SignUpView()
                }

                Button(action: {
                    if viewModel.validateEmail(), viewModel.validatePassword() {
                        viewModel.signIn()
                     }
                }) {
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

