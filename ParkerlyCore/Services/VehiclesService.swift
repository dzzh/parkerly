//
// Created by Zmicier Zaleznicenka on 5/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

// MARK: - VehiclesService

// When implementing this service, I didn't spend time on enforcing rules for a default vehicle,
// i.e. making sure that if there's only one vehicle it's made default, and if there are more,
// there's always one and only one default. Ideally, this is something backend should do.
public protocol VehiclesServiceType: ParkerlyServiceType {

    func create(_ vehicle: Vehicle, completion: ((ParkerlyServiceOperation<Vehicle>) -> Void)?)

    func delete(_ vehicle: Vehicle, completion: ((ParkerlyServiceOperation<Void>) -> Void)?)

    func edit(_ vehicle: Vehicle, completion: ((ParkerlyServiceOperation<Vehicle>) -> Void)?)

    func getVehicle(_ id: NetworkId, userId: NetworkId, completion: ((ParkerlyServiceOperation<Vehicle>) -> Void)?)

    func getVehicles(for user: User, completion: ((ParkerlyServiceOperation<[Vehicle]>) -> Void)?)

    func getDefault(for user: User, completion: ((ParkerlyServiceOperation<Vehicle>) -> Void)?)
}

public class VehiclesService: ParkerlyService {

    private let modelRequest = NetworkModelRequest<Vehicle>.self
}

extension VehiclesService: VehiclesServiceType {

    public func create(_ vehicle: Vehicle, completion: ((ParkerlyServiceOperation<Vehicle>) -> Void)?) {
        let createRequest = modelRequest.createModel(vehicle.copyWithoutId)
        let getRequest: (NetworkId) -> NetworkRequestType? = { [weak self] id in
            return self?.modelRequest.getModel(modelId: id, userId: vehicle.userId)
        }
        crudService.createModel(createRequest: createRequest, getRequest: getRequest, completion: completion)
    }

    public func delete(_ vehicle: Vehicle, completion: ((ParkerlyServiceOperation<Void>) -> Void)?) {
        guard vehicle.id != nil else {
            os_log("Cannot delete vehicle without id")
            completion?(ParkerlyServiceOperation.failed(.malformedRequest))
            return
        }

        let deleteRequest = modelRequest.deleteModel(vehicle)
        crudService.deleteModel(request: deleteRequest, completion: completion)
    }

    public func edit(_ vehicle: Vehicle, completion: ((ParkerlyServiceOperation<Vehicle>) -> Void)?) {
        guard vehicle.id != nil else {
            os_log("Cannot delete vehicle without id")
            completion?(ParkerlyServiceOperation.failed(.malformedRequest))
            return
        }

        let editRequest = modelRequest.editModel(vehicle)
        crudService.editModel(request: editRequest, completion: completion)
    }

    public func getVehicle(_ id: NetworkId, userId: NetworkId,
                           completion: ((ParkerlyServiceOperation<Vehicle>) -> Void)?) {
        let getRequest = modelRequest.getModel(modelId: id, userId: userId)
        crudService.getModel(request: getRequest, completion: completion)
    }

    public func getVehicles(for user: User, completion: ((ParkerlyServiceOperation<[Vehicle]>) -> Void)?) {
        guard let userId = user.id else {
            os_log("Cannot fetch vehicles for a user without id")
            completion?(ParkerlyServiceOperation.failed(.malformedRequest))
            return
        }

        let getRequest = modelRequest.getModels(userId: userId)
        crudService.getModels(request: getRequest, completion: completion)
    }

    public func getDefault(for user: User, completion: ((ParkerlyServiceOperation<Vehicle>) -> Void)?) {
        getVehicles(for: user) { operation in
            switch operation {
            case .completed(let vehicles):
                if let defaultVehicle = vehicles.first(where: { $0.isDefault == true }) {
                    completion?(ParkerlyServiceOperation.completed(defaultVehicle))
                } else {
                    completion?(ParkerlyServiceOperation.failed(.noData))
                }
            case .failed(let error):
                    completion?(ParkerlyServiceOperation.failed(error))
            }
        }
    }
}
