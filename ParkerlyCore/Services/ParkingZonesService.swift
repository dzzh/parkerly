//
// Created by Zmicier Zaleznicenka on 5/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

// I suppose, in production app it would make sense to provide a bounding box here
// to limit the number of results, and only fetch zones after reaching certain map zoom level.
public protocol ParkingZonesServiceType: ParkerlyServiceType {

    func get(completion: ((ParkerlyServiceOperation<[ParkingZone]>) -> Void)?)
}

class ParkingZonesService {

    // TODO: caching
}

// TODO: connect to network service
extension ParkingZonesService: ParkingZonesServiceType {

    func get(completion: ((ParkerlyServiceOperation<[ParkingZone]>) -> Void)?) {
        let zones: [ParkingZone] = [
            ParkingZone(id: "z1", address: "Amsterdam, Wisselwerking 40", lat: 52.3268841, lon: 4.9499596, tariff: "5 eur/hr"),
            ParkingZone(id: "z2", address: "Amsterdam, Diemen Zuid", lat: 52.3268841, lon: 4.9499596, tariff: "3 eur/hr")
        ]
        completion?(ParkerlyServiceOperation.completed(zones))
    }
}
