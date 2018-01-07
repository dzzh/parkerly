//
// Created by Zmicier Zaleznicenka on 6/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

public enum HttpMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

public protocol RequestFactoryType {

    func request(with path: String?, method: HttpMethod, body: Data?) -> URLRequest?
}

class RequestFactory {

    // Not the best place to keep it, but will work for a sample app
    private let baseUrl = "https://parking-thing.firebaseio.com"
}

extension RequestFactory: RequestFactoryType {

    public func request(with path: String?, method: HttpMethod, body: Data? = nil) -> URLRequest? {
        guard let _path = path, let url = url(for: _path) else {
            os_log("Couldn't generate valid URL for path %@", path ?? "nil")
            return nil
        }
        var request = baseRequest(for: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        return request
    }

    private func url(for path: String) -> URL? {
        return URL(string: baseUrl + path)
    }

    private func baseRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
