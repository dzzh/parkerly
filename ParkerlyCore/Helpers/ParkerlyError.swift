//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

public enum ParkerlyError: Error {
    case internalError(description: String)
    case malformedData
    case malformedRequest
    case unknown
}

extension Error {

    public var parkerlyError: ParkerlyError {
        os_log("Expected ParkerlyError, got %@", self.localizedDescription)
        return self as? ParkerlyError ?? ParkerlyError.unknown
    }
}
