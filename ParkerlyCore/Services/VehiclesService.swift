//
// Created by Zmicier Zaleznicenka on 5/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

public protocol VehiclesServiceType: ParkerlyServiceType {

    func get(for user: User, completion: ((ParkerlyServiceOperation<[Vehicle]>) -> Void)?)

    func edit(_ vehicle: Vehicle, completion: ((ParkerlyServiceOperation<Void>) -> Void)?)

    func remove(_ vehicle: Vehicle, completion: ((ParkerlyServiceOperation<Void>) -> Void)?)
}

public class VehiclesService {
    // TODO: caching

    private let networkService: NetworkServiceType

    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }
}

// TODO: implement, connect to network service
extension VehiclesService: VehiclesServiceType {

    public func get(for user: User, completion: ((ParkerlyServiceOperation<[Vehicle]>) -> Void)?) {
        let vehicles: [Vehicle] = [
            Vehicle(id: "v1", userId: "user1", title: "u1-v1", vrn: "xxx-1"),
            Vehicle(id: "v2", userId: "user1", title: "u1-v2", vrn: "xxx-2"),
            Vehicle(id: "v3", userId: "user2", title: "u2-v1", vrn: "yyy-1")
        ]
        let vehiclesForUser = vehicles.filter { vehicle in vehicle.userId == user.id }
        completion?(ParkerlyServiceOperation.completed(vehiclesForUser))
    }

    public func edit(_ vehicle: Vehicle, completion: ((ParkerlyServiceOperation<Void>) -> Void)?) {
        os_log("not implemented")
        completion?(ParkerlyServiceOperation.completed(()))
    }

    public func remove(_ vehicle: Vehicle, completion: ((ParkerlyServiceOperation<Void>) -> Void)?) {
        os_log("not implemented")
        completion?(ParkerlyServiceOperation.completed(()))
    }

}
