//
//  AuthView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/10.
//

import GoogleSignIn
import GoogleSignInSwift
import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    let apiclient = APIClient.shared

    var body: some View {
        VStack {
            Button {
                Task {
                    let request = SignupRequest(token: "hogehoge", user_name: "APIのテストだよん", auth_id: 777)
                    print(request)
                    do {
                        let response = try await apiclient.call(request: request)
                        print("😁response--------------------")
                        print("id: \(response.id)    \n")
                        print("--------------------")
                    } catch {
                        print("Error occurred: \(error)")
                    }
                }
            } label: {
                Text("あああ")
            }
        }
    }
}

struct GoogleSignInView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
