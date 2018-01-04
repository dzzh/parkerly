//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

public struct ParkingAction {

    public let id: String?
    public let startDate: Date
    public let endDate: Date?
    public let userId: String
    public let vehicleId: String
    public let zoneId: String

    public init(id: String?, startDate: Date, endDate: Date?, userId: String, vehicleId: String, zoneId: String) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.userId = userId
        self.vehicleId = vehicleId
        self.zoneId = zoneId
    }

    public init(userId: String, vehicleId: String, zoneId: String) {
        self.init(id: nil, startDate: Date(), endDate: nil, userId: userId, vehicleId: vehicleId, zoneId: zoneId)
    }

    // TODO: abstract formatting out to a separate service
    public var startDateString: String {
        return dateFormatter.string(from: startDate)
    }

    public var endDateString: String {
        guard let endDate = endDate else {
            os_log("Tried to format date for missing endDate")
            return "n/a"
        }
        return dateFormatter.string(from: endDate)
    }
}

private extension ParkingAction {

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        return formatter
    }
}
