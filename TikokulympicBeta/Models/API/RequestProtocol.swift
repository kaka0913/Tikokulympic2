//
//  RequestProtocol.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/16.
//

import Alamofire
import Foundation

protocol ResponseProtocol: Decodable {}

protocol RequestProtocol: Encodable {
    associatedtype Response: ResponseProtocol
    var baseUrl: String { get }
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
    var query: Parameters? { get }
    var encoding: Alamofire.ParameterEncoding { get }
    var parameters: Alamofire.Parameters? { get }
    var headers: Alamofire.HTTPHeaders? { get }
    var decoder: JSONDecoder { get }
}

extension RequestProtocol {
    var baseUrl: String {
        return "https://watnow-hack2024.onrender.com"
    }
    var encoding: Alamofire.ParameterEncoding {
        return JSONEncoding.default
    }
    var query: Parameters? {
        return nil
    }
    var parameters: Alamofire.Parameters? {
        return nil
    }
    var headers: Alamofire.HTTPHeaders? {
        return [
            "Content-Type": "application/json"
        ]
    }

    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
