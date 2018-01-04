//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

public struct ParkingZone {

    public let id: String
    public let address: String
    public let lat: Double
    public let lon: Double
    public let tariff: String

    public init(id: String, address: String, lat: Double, lon: Double, tariff: String) {
        self.id = id
        self.address = address
        self.lat = lat
        self.lon = lon
        self.tariff = tariff
    }
}
