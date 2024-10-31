import Alamofire
import Foundation

struct SignupResponse: ResponseProtocol {
    let id: Int
}

struct SignupRequest: RequestProtocol {
    typealias Response = SignupResponse
    var method: HTTPMethod { .post }
    var path: String { "/auth/signup" }
    let token: String
    let user_name: String
    let auth_id: Int

    var parameters: Parameters? {
        return [
            "token": token,
            "user_name": user_name,
            "auth_id": auth_id,
        ]
    }
}
