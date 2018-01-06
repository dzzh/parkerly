//
// Created by Zmicier Zaleznicenka on 6/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

protocol NetworkRequestType: CustomDebugStringConvertible {

    var servicePath: String? { get }

    var requestPath: String? { get }

    var queryParameters: [String:String] { get }

    var fullPath: String? { get }

    var method: HttpMethod { get }

    func urlRequest(_ requestFactory: RequestFactoryType) -> URLRequest?
}

extension NetworkRequestType {

    var queryParameters: [String:String] {
        return [:]
    }

    var fullPath: String? {
        let service = servicePath ?? ""
        let request = requestPath != nil ? "/\(requestPath!)" : ""
        let suffix = "/.json"

        let params: String
        if queryParameters.isEmpty {
            params = ""
        } else {
            params = "?" + queryParameters.map { "\($0)=\($1)" }.joined(separator: "&")
        }

        return "\(service)\(request)\(suffix)\(params)"
    }

    // MARK: - CustomDebugStringConvertible

    var debugDescription: String {
        return "\(method) \(fullPath ?? "nil")"
    }
}
