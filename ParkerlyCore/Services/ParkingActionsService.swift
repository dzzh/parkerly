//
// Created by Zmicier Zaleznicenka on 5/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

public protocol ParkingActionsServiceType: ParkerlyServiceType {

    func getActive(for user: User, completion: ((ParkerlyServiceOperation<[ParkingAction]>) -> Void)?)

    func getCompleted(for user: User, completion: ((ParkerlyServiceOperation<[ParkingAction]>) -> Void)?)

    func start(_ parkingAction: ParkingAction, completion: ((ParkerlyServiceOperation<ParkingAction>) -> Void)?)

    func stop(_ parkingAction: ParkingAction, completion: ((ParkerlyServiceOperation<ParkingAction>) -> Void)?)
}

public class ParkingActionsService: ParkerlyService {

    private let modelRequest = NetworkModelRequest<ParkingAction>.self
}

extension ParkingActionsService: ParkingActionsServiceType {

    public func getActive(for user: User, completion: ((ParkerlyServiceOperation<[ParkingAction]>) -> Void)?) {
        let predicate: (ParkingAction) -> Bool = {
            return $0.userId == user.id && $0.startDate != nil && $0.stopDate == nil
        }
        getActions(for: user, predicate: predicate, completion: completion)
    }

    public func getCompleted(for user: User, completion: ((ParkerlyServiceOperation<[ParkingAction]>) -> Void)?) {
        let predicate: (ParkingAction) -> Bool = {
            return $0.userId == user.id && $0.startDate != nil && $0.stopDate != nil
        }
        getActions(for: user, predicate: predicate, completion: completion)
    }

    public func start(_ parkingAction: ParkingAction, completion: ((ParkerlyServiceOperation<ParkingAction>) -> Void)?) {
        let startedAction = parkingAction.copy(withStartDate: Date()).copyWithoutId
        let createRequest = modelRequest.createModel(startedAction)
        let getRequest: (NetworkId) -> NetworkRequestType? = { [weak self] id in
            return self?.modelRequest.getModel(modelId: id, userId: parkingAction.userId)
        }
        crudService.createModel(createRequest: createRequest, getRequest: getRequest, completion: completion)
    }

    public func stop(_ parkingAction: ParkingAction, completion: ((ParkerlyServiceOperation<ParkingAction>) -> Void)?) {
        guard let actionId = parkingAction.id else {
            completion?(ParkerlyServiceOperation.failed(.malformedRequest))
            return
        }
        let editRequest = modelRequest.editModel(parkingAction.copy(withEndDate: Date()))
        crudService.editModel(request: editRequest, id: actionId, completion: completion)
    }
}

private extension ParkingActionsService {

    private func getActions(for user: User, predicate: @escaping (ParkingAction) -> Bool,
                            completion: ((ParkerlyServiceOperation<[ParkingAction]>) -> Void)?) {
        guard let userId = user.id else {
            os_log("Cannot fetch actions without user id")
            completion?(ParkerlyServiceOperation.failed(.malformedRequest))
            return
        }

        crudService.getModels(request: modelRequest.getModels(userId: userId)) {
            (operation: ParkerlyServiceOperation<[ParkingAction]>) -> Void in

            DispatchQueue.main.async {
                switch operation {
                case .completed(let actions):
                    let filteredActions = actions.filter(predicate)
                    completion?(ParkerlyServiceOperation.completed(filteredActions))
                case .failed(_):
                    completion?(operation)
                }
            }
        }
    }
}