//
//  APIClient.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/15.
//

import Alamofire
import Foundation

class APIClient {
    static let shared = APIClient()
    private init() {}

    func call<T: RequestProtocol>(request: T) async throws -> T.Response {
        let requestUrl = request.baseUrl + request.path

        let method = request.method
        let headers = request.headers

        // ベースURLとパスを結合
        var urlComponents = URLComponents(string: requestUrl)

        // クエリパラメータを追加
        if let queryParameters = request.query, !queryParameters.isEmpty {
            let queryItems = queryParameters.map { key, value -> URLQueryItem in
                URLQueryItem(name: key, value: "\(value)")
            }
            urlComponents?.queryItems = queryItems
        } else {
            urlComponents?.queryItems = nil
        }

        guard let url = urlComponents?.url else {

            throw APIError.invalidResponse
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        urlRequest.headers = headers ?? HTTPHeaders()

        if let bodyParameters = request.parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters)
            } catch {
                throw APIError.requestFailed(error)
            }
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(urlRequest)
                .validate()
                .responseDecodable(of: T.Response.self, decoder: request.decoder) { response in
                    let statusCode = response.response?.statusCode ?? -1
                    switch response.result {
                    case .success(let result):
                        continuation.resume(returning: result)
                    case .failure(let error):
                        let data = response.data
                        if (200..<300).contains(statusCode) {
                            // ステータスコードは成功だが、デコードに失敗した場合
                            continuation.resume(throwing: APIError.decodingError(error))
                            print("🧐")
                        } else if (400..<500).contains(statusCode) {
                            // クライアントエラー
                            continuation.resume(
                                throwing: APIError.clientError(statusCode: statusCode, data: data))
                            print("😄")
                        } else if (500..<600).contains(statusCode) {
                            // サーバーエラー
                            continuation.resume(
                                throwing: APIError.serverError(statusCode: statusCode, data: data))
                            print("😂")
                        } else {
                            // その他のエラー
                            continuation.resume(
                                throwing: APIError.unknownError(
                                    statusCode: statusCode, data: data, error: error))
                            print("🫅")
                        }
                    }
                }
        }
    }
}
