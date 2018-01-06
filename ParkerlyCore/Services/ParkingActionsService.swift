//
// Created by Zmicier Zaleznicenka on 5/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

public protocol ParkingActionsServiceType: ParkerlyServiceType {

    func get(for user: User, completion: ((ParkerlyServiceOperation<[ParkingAction]>) -> Void)?)

    func getActive(for user: User, completion: ((ParkerlyServiceOperation<[ParkingAction]>) -> Void)?)

    func start(_ parkingAction: ParkingAction, completion: ((ParkerlyServiceOperation<ParkingAction>) -> Void)?)

    func stop(_ parkingAction: ParkingAction, completion: ((ParkerlyServiceOperation<ParkingAction>) -> Void)?)
}

public class ParkingActionsService {

    // TODO: caching
}

// TODO: implement, connect to network service
extension ParkingActionsService: ParkingActionsServiceType {

    public func get(for user: User, completion: ((ParkerlyServiceOperation<[ParkingAction]>) -> Void)?) {
        let actions: [ParkingAction] = [
            ParkingAction(id: "action1", startDate: nil, endDate: nil, userId: "user1", vehicleId: "u1-v1", zoneId: "z1"),
            ParkingAction(id: "action2", startDate: Date(), endDate: nil, userId: "user1", vehicleId: "u1-v1", zoneId: "z1"),
            ParkingAction(id: "action3", startDate: nil, endDate: nil, userId: "user2", vehicleId: "u1-v1", zoneId: "z1")
        ]
        let actionsForUser = actions.filter { action in action.userId == user.id }
        completion?(ParkerlyServiceOperation.completed(actionsForUser))
    }

    public func getActive(for user: User, completion: ((ParkerlyServiceOperation<[ParkingAction]>) -> Void)?) {
        get(for: user) { operation in
            switch operation {
            case .completed(let actions):
                let activeActions = actions.filter { action in action.startDate != nil && action.endDate == nil }
                completion?(ParkerlyServiceOperation.completed(activeActions))
            case .failed:
                break // TODO: error handling
            }
        }
    }

    // TODO: implement
    public func start(_ parkingAction: ParkingAction, completion: ((ParkerlyServiceOperation<ParkingAction>) -> Void)?) {
        let startedAction = parkingAction.copy(withStartDate: Date())
        completion?(ParkerlyServiceOperation.completed(startedAction))
    }

    public func stop(_ parkingAction: ParkingAction, completion: ((ParkerlyServiceOperation<ParkingAction>) -> Void)?) {
        let stoppedAction = parkingAction.copy(withEndDate: Date())
        completion?(ParkerlyServiceOperation.completed(stoppedAction))
    }

}
