//
//  SignInViewModel.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/10.
//

import GoogleSignIn
import GoogleSignInSwift
import Supabase
import SwiftUI

//AuthViewModelはAuthViewのみに対して使用したいため、ViewModelを作成
class AuthViewModel: ObservableObject {
    @Published var isSignedIn: Bool = false
    let authService = AuthService.shared
    
    // Googleサインイン
    func signInWithGoogle() async {
        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) {
            signInResult, error in
            guard let result = signInResult else {
                if let error = error {
                    print("Error signing in: \(error.localizedDescription)")
                }
                return
            }

            if let idToken = result.user.idToken?.tokenString {
                Task {
                    await self.signInToSupabase(withIdToken: idToken)
                }
            } else {
                print("Failed to get idToken from Google Sign-In result.")
            }
        }
    }

    // Supabaseにサインイン
    func signInToSupabase(withIdToken idToken: String) async {
        guard let client = SupabaseClientManager.shared.client else {
            print("😁SupabaseClient is not initialized.")
            return
        }

        Task {
            do {
                _ = try await client.auth.signInWithIdToken(
                    credentials: .init(
                        provider: .google,
                        idToken: idToken
                    )
                )
                await MainActor.run {
                    self.isSignedIn = true
                    print("Supabase Sign-in Success")
                }
                
                //TOOD: モックデータでAPI実行
                let response = try await authService.postSignup(
                    token: "hogehoge", 
                    userName: "APIのテストだよん",
                    authId: 777
                )
                
                print("👩‍🚀\(response)")
                
                print("🥷\(response.id)")
                UserDefaults.standard.set(response.id, forKey: "userId")
                

            } catch let error as APIError {
                print("😁Supabase Sign-in Error: \(error.localizedDescription)")
                switch error {
                case .invalidResponse:
                    print("URLが無効です。")
                case .requestFailed(let underlyingError):
                    print("リクエストが失敗しました: \(underlyingError.localizedDescription)")
                case .serverError(let statusCode):
                    print("サーバーエラーが発生しました。ステータスコード: \(statusCode)")
                case .decodingError(let underlyingError):
                    print("デコードエラーが発生しました: \(underlyingError.localizedDescription)")
                case .unknownError:
                    print("不明なエラーが発生しました。")
                case .clientError(let statusCode, let data):
                    print("クライアント側でのエラーが発生しました。")
                }
            }
        }
    }

    // サインアウトの処理
    func signOut() async {
        GIDSignIn.sharedInstance.signOut()
        guard let client = SupabaseClientManager.shared.client else {
            print("SupabaseClient is not initialized.")
            return
        }

        do {
            try await client.auth.signOut()
            await MainActor.run {
                self.isSignedIn = false
                print("Signed out of both Google and Supabase")
            }
        } catch {
            print("Error signing out of Supabase: \(error.localizedDescription)")
        }
    }

    // ルートビューコントローラの取得
    private func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let root = screen.windows.first?.rootViewController
        else {
            return UIViewController()
        }
        return root
    }
}
