//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

public struct ParkingAction: ParkerlyModel {

    // MARK: - Codable

    // TODO: properly encode/decode parking action

    // MARK: - State

    public static let servicePath: String = "/parkingActions"

    public let id: NetworkId?
    public let startDate: Date?
    public let stopDate: Date?
    public let userId: String
    public let vehicleId: String
    public let zoneId: String

    // MARK: - Initialization

    public init(id: NetworkId?, startDate: Date?, stopDate: Date?, userId: NetworkId, vehicleId: NetworkId, zoneId: NetworkId) {
        self.id = id
        self.startDate = startDate
        self.stopDate = stopDate
        self.userId = userId
        self.vehicleId = vehicleId
        self.zoneId = zoneId
    }

    public init(userId: NetworkId, vehicleId: NetworkId, zoneId: NetworkId) {
        self.init(id: nil, startDate: nil, stopDate: nil, userId: userId, vehicleId: vehicleId, zoneId: zoneId)
    }

    public init?(user: User, vehicle: Vehicle, zone: ParkingZone) {
        guard let userId = user.id, let vehicleId = vehicle.id, let zoneId = zone.id else {
            os_log("invalid parameters")
            return nil
        }
        self.id = nil
        self.startDate = nil
        self.stopDate = nil
        self.userId = userId
        self.vehicleId = vehicleId
        self.zoneId = zoneId
    }

    // MARK: - Copying

    public var copyWithoutId: ParkingAction {
        return ParkingAction(id: nil, startDate: startDate, stopDate: stopDate, userId: userId, vehicleId: vehicleId, zoneId: zoneId)
    }

    public func copy(withId id: NetworkId?) -> ParkingAction {
        return ParkingAction(id: id, startDate: startDate, stopDate: stopDate, userId: userId, vehicleId: vehicleId, zoneId: zoneId)
    }

    func copy(withStartDate date: Date) -> ParkingAction {
        return ParkingAction(id: self.id, startDate: date, stopDate: self.stopDate, userId: self.userId,
            vehicleId: self.vehicleId, zoneId: self.zoneId)
    }

    func copy(withEndDate date: Date) -> ParkingAction {
        return ParkingAction(id: self.id, startDate: self.startDate, stopDate: date, userId: self.userId,
            vehicleId: self.vehicleId, zoneId: self.zoneId)
    }

    // MARK: - Interface

    // TODO: abstract formatting out to a separate service
    public var startDateString: String {
        guard let startDate = startDate else {
            return "n/a"
        }
        return dateFormatter.string(from: startDate)
    }

    public var endDateString: String {
        guard let stopDate = stopDate else {
            return "n/a"
        }
        return dateFormatter.string(from: stopDate)
    }
}

private extension ParkingAction {

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        return formatter
    }
}
