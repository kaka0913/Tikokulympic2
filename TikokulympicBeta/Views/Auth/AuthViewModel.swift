//
//  AuthViewModel.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/11/01.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var emailError: String?
    @Published var passwordError: String?
    @Published var isSignUpSuccess: Bool = false
    @Published var isSignInSuccess: Bool = false
    let authService = AuthService.shared

    func validateEmail() -> Bool {
        if email.isEmpty {
            emailError = "メールアドレスを入力してください"
            return false
        } else if !isValidEmail(email) {
            emailError = "有効なメールアドレスを入力してください"
            return false
        } else {
            emailError = nil
            return true
        }
    }

    func validatePassword() -> Bool {
        if password.isEmpty {
            passwordError = "パスワードを入力してください"
            return false
        } else if password.count < 6 {
            passwordError = "パスワードは6文字以上で入力してください"
            return false
        } else {
            passwordError = nil
            return true
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }

            if let error = error {
                print("Firebaseのサインインに失敗しました: \(error)")
            } else if let uid = authResult?.user.uid {
                print("Firebaseのサインインに成功しました")
                
                Task {
                    do {
                        let userid = try await self.authService.postSignin(id: uid).id
                        UserDefaults.standard.set(userid, forKey: "userid")
                        
                        DispatchQueue.main.async {
                            self.isSignInSuccess = true
                        }
                    } catch {
                        print("サインイン後の処理に失敗しました: \(error)")
                    }
                }
            }
        }
    }

    func signUp() async {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }

            if let error = error {
                print("Firebaseのサインアップに失敗しました: \(error)")
            } else if let uid = authResult?.user.uid {
                print("Firebaseのサインアップに成功しました")
                
                SignupUserProfileModel.shared.authid = uid
                
                DispatchQueue.main.async {
                    self.isSignUpSuccess = true
                }
            }
        }
    }
}
