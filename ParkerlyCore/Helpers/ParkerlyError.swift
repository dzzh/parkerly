//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

public enum ParkerlyError: Error {
    case internalError(description: String?)
    case malformedData
    case malformedRequest
    case notImplemented
    case unknown
    case userError(userMessage: String)

    public var userDescription: String {
        switch self {
        case .internalError(_), .notImplemented: return "Internal error; we're on it"
        case .malformedData: return "Web service has returned malformed data"
        case .malformedRequest: return "Web service had troubles parsing an incoming request"
        case .unknown: return "It's not exactly clear what happened, that's all we know"
        case .userError(let userMessage): return userMessage
        }
    }
}

extension Error {

    public var parkerlyError: ParkerlyError {
        os_log("Expected ParkerlyError, got %@", self.localizedDescription)
        return self as? ParkerlyError ?? ParkerlyError.unknown
    }
}
