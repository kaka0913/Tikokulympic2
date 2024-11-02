import Alamofire
import Foundation

struct SignupResponse: ResponseProtocol {
    let id: Int
}

struct SignupRequest: RequestProtocol {
    typealias Response = SignupResponse
    var method: HTTPMethod { .post }
    var path: String { "/auth/signup" }
    let user_name: String
    let auth_id: String
    let token: String

    var parameters: Parameters? {
        return [
            "user_name": user_name,
            "auth_id": auth_id,
            "token": token
        ]
    }
}
