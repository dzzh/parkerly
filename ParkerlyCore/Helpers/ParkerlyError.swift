//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

public enum ParkerlyError: Error {
    case internalError(description: String?)
    case locationServicesDisabled
    case malformedData
    case malformedRequest
    case noData
    case noParkingZoneSelected
    case noVehicleSelected
    case notImplemented
    case notLoggedIn
    case unknown
    case userError(userMessage: String)

    public var userDescription: String {
        switch self {
        case .internalError(_), .notImplemented: return "Internal error; we're on it"
        case .locationServicesDisabled: return "Please enable location services"
        case .malformedData: return "Web service has returned malformed data"
        case .malformedRequest: return "Web service had troubles parsing an incoming request"
        case .noParkingZoneSelected: return "Select a parking zone"
        case .noVehicleSelected: return "Select a vehicle"
        case .notLoggedIn: return "You have to log in to complete this action"
        case .noData: return "There's no data in the database"
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
