//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

public struct ParkingZone: ParkerlyModel {

    public var id: NetworkId?
    public let address: String
    public let lat: Double
    public let lon: Double
    public let tariff: String

    public init(id: NetworkId?, address: String, lat: Double, lon: Double, tariff: String) {
        self.id = id
        self.address = address
        self.lat = lat
        self.lon = lon
        self.tariff = tariff
    }

    public var copyWithoutId: ParkingZone {
        return ParkingZone(id: nil, address: address, lat: lat, lon: lon, tariff: tariff)
    }

    public func copy(withId id: NetworkId?) -> ParkingZone {
        return ParkingZone(id: id, address: address, lat: lat, lon: lon, tariff: tariff)
    }
}
