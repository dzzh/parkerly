//
// Created by Zmicier Zaleznicenka on 6/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

protocol NetworkRequestType: CustomDebugStringConvertible {

    var servicePath: String { get }

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
        let request = requestPath != nil ? "/\(requestPath!)" : ""
        let suffix = "/.json"

        let params: String
        if queryParameters.isEmpty {
            params = ""
        } else {
            params = "?" + queryParameters.map { "\($0)=\($1)" }.joined(separator: "&")
        }

        return "\(servicePath)\(request)\(suffix)\(params)"
    }

    // MARK: - CustomDebugStringConvertible

    var debugDescription: String {
        return "\(method) \(fullPath ?? "nil")"
    }
}

enum NetworkModelRequest<T: ParkerlyModel> {
    case createModel(T)
    case deleteModel(T)
    case editModel(T)
    case getModel(modelId: NetworkId, userId: NetworkId)
    case getModels(userId: NetworkId)
}

extension NetworkModelRequest: NetworkRequestType {

    var servicePath: String {
        return T.servicePath
    }

    var requestPath: String? {
        switch self {
        case .createModel(_), .getModels(_):
            return nil
        case .deleteModel(let model):
            guard let modelId = model.id else {
                os_log("Cannot modify a model without an id")
                return nil
            }
            return modelId
        case .editModel(let model):
            guard let modelId = model.id else {
                os_log("Cannot modify a model without an id")
                return nil
            }
            return modelId
        case .getModel(let modelId, _):
            return modelId
        }
    }

    var queryParameters: [String: String] {
        switch self {
        case .getModels(let userId):
            return [
                "orderBy": "userId",
                "startAt": userId,
                "endAt": userId
            ]
        case .createModel(_), .deleteModel(_), .editModel(_), .getModel(_, _):
            return [:]
        }
    }

    var method: HttpMethod {
        switch self {
        case .createModel(_): return .post
        case .editModel(_): return .patch
        case .deleteModel(_): return .delete
        case .getModel(_, _), .getModels(_): return .get
        }
    }

    func urlRequest(_ requestFactory: RequestFactoryType) -> URLRequest? {
        let body: Data?
        switch self {
        case .createModel(let model):
            guard let _body = model.copyWithoutId.encoded else {
                os_log("Couldn't encode model %@", model.debugDescription)
                return nil
            }
            body = _body
        case .editModel(let model):
            guard let _body = model.copyWithoutId.encoded else {
                os_log("Couldn't encode model %@", model.debugDescription)
                return nil
            }
            body = _body
        case .deleteModel(_), .getModel(_, _), .getModels(_):
            return nil
        }
        return requestFactory.request(with: fullPath, method: method, body: body)
    }
}
