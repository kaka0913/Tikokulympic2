import Foundation
import Alamofire


struct UserNameEditResponse: ResponseProtocol, Decodable {
    let is_success: Bool
}

struct UserNameEditRequest: RequestProtocol, Decodable {
    typealias Response = UserNameEditResponse
    var userId: Int
    var name: String
    var method: HTTPMethod { .put }
    var path: String { "/users/\(userId)/profile/name" }
    var parameters: Parameters? {
        return ["name": name]
    }
}
