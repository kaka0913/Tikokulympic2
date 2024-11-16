import Foundation
import Alamofire

class UserService {
    static let shared = UserService()
    public init() {}
    func updateUserName(userId: Int, name: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let request = UserNameEditRequest(userId: userId, name: name)
        AF.request(
            request.path,
            method: request.method,
            parameters: request.parameters,
            encoding: JSONEncoding.default
        ).responseDecodable(of: UserNameEditResponse.self) { response in
            switch response.result {
            case .success(let responseData):
                completion(.success(responseData.is_success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func getUserProfile(userId: Int, completion: @escaping (Result<UserNameEditRequest, Error>) -> Void) {
        let url = "/users/\(userId)/profile/name"  // ユーザーIDを埋め込む

        AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default
        ).responseDecodable(of: UserNameEditRequest.self) { response in
            switch response.result {
            case .success(let profileData):
                completion(.success(profileData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
