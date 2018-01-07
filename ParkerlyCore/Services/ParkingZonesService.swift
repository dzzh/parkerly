//
// Created by Zmicier Zaleznicenka on 5/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

private struct GetZonesRequest: NetworkRequestType {

    let servicePath: String = ParkingZone.servicePath
    let requestPath: String? = nil
    let method: HttpMethod = .get

    func urlRequest(_ requestFactory: RequestFactoryType) -> URLRequest? {
        return requestFactory.request(with: fullPath, method: method, body: nil)
    }
}

// I suppose, in production app it would make sense to provide a bounding box here
// to limit the number of results, and only fetch zones after reaching certain map zoom level.
public protocol ParkingZonesServiceType: ParkerlyServiceType {

    func getZones(completion: ((ParkerlyServiceOperation<[ParkingZone]>) -> Void)?)
}

class ParkingZonesService: ParkerlyService {

    private let modelRequest = NetworkModelRequest<ParkingZone>.self
}

extension ParkingZonesService: ParkingZonesServiceType {

    func getZones(completion: ((ParkerlyServiceOperation<[ParkingZone]>) -> Void)?) {
        let getRequest = GetZonesRequest()
        crudService.getModels(request: getRequest, completion: completion)
    }
}
