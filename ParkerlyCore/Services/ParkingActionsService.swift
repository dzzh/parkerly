//
// Created by Zmicier Zaleznicenka on 5/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

enum ParkingActionsServiceRequest {
    case getActiveActions(userId: NetworkId)
    case getCompletedActions(userId: NetworkId)
    case startParkingAction(parkingAction: ParkingAction)
    case stopParkingAction(parkingAction: ParkingAction)
}

extension ParkingActionsServiceRequest: NetworkRequestType {

    var servicePath: String? {
        return "/parkingActions"
    }

    // TODO: Because Firebase indices are not enabled, we cannot query by user, that's why the code is commented.
    // Now, the application filters the results at the client side.
    var requestPath: String? {
        switch self {
        case .getActiveActions(_), .getCompletedActions(_):
//            return userId
            return nil
        case .startParkingAction:
            return nil
        case .stopParkingAction(let parkingAction):
            guard let id = parkingAction.id else {
                os_log("Can't stop a parking action without an id")
                return nil
            }
            return id
        }
    }

    // TODO: Because Firebase indices are not enabled, we cannot query by user, that's why the code is commented.
    // Now, the application filters the results at the client side.
    var queryParameters: [String: String] {
        switch self {
        case .getActiveActions(_), .getCompletedActions(_):
//            return [
//                "orderBy": "user",
//                "startAt": userId,
//                "endAt": userId
//            ]
            return [:]
        case .startParkingAction(_), .stopParkingAction(_):
            return [:]
        }
    }

    var method: HttpMethod {
        switch self {
        case .startParkingAction(_): return .post
        case .getActiveActions(_), .getCompletedActions(_): return .get
        case .stopParkingAction(_): return .patch
        }
    }

    func urlRequest(_ requestFactory: RequestFactoryType) -> URLRequest? {
        let body: Data?
        switch self {
        case .getActiveActions(_), .getCompletedActions(_):
            return nil
        case .startParkingAction(let action), .stopParkingAction(let action):
            guard let _body = action.copyWithoutId.encoded else {
                os_log("Couldn't encode action %@", action.debugDescription)
                return nil
            }
            body = _body
        }
        return requestFactory.request(with: fullPath, method: method, body: body)
    }
}

public protocol ParkingActionsServiceType: ParkerlyServiceType {

    func getActive(for user: User, completion: ((ParkerlyServiceOperation<[ParkingAction]>) -> Void)?)

    func getCompleted(for user: User, completion: ((ParkerlyServiceOperation<[ParkingAction]>) -> Void)?)

    func start(_ parkingAction: ParkingAction, completion: ((ParkerlyServiceOperation<ParkingAction>) -> Void)?)

    func stop(_ parkingAction: ParkingAction, completion: ((ParkerlyServiceOperation<ParkingAction>) -> Void)?)
}

public class ParkingActionsService {

    // TODO: Caching

    private let networkService: NetworkServiceType

    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }
}

extension ParkingActionsService: ParkingActionsServiceType {

    public func getActive(for user: User, completion: ((ParkerlyServiceOperation<[ParkingAction]>) -> Void)?) {
        let predicate: (ParkingAction) -> Bool = {
            return $0.userId == user.id && $0.startDate != nil && $0.endDate == nil
        }
        getActions(for: user, predicate: predicate, completion: completion)
    }

    public func getCompleted(for user: User, completion: ((ParkerlyServiceOperation<[ParkingAction]>) -> Void)?) {
        let predicate: (ParkingAction) -> Bool = {
            return $0.userId == user.id && $0.startDate != nil && $0.endDate != nil
        }
        getActions(for: user, predicate: predicate, completion: completion)
    }

    public func start(_ parkingAction: ParkingAction, completion: ((ParkerlyServiceOperation<ParkingAction>) -> Void)?) {
        let startedAction = parkingAction.copy(withStartDate: Date()).copyWithoutId
        networkService.requestId(ParkingActionsServiceRequest.startParkingAction(parkingAction: startedAction)) {
            operation in
            switch operation {
            case .completed(let actionId):
                completion?(ParkerlyServiceOperation.completed(startedAction.copy(withId: actionId)))
            case .failed(let error):
                completion?(ParkerlyServiceOperation.failed(error))
            }
        }
    }

    public func stop(_ parkingAction: ParkingAction, completion: ((ParkerlyServiceOperation<ParkingAction>) -> Void)?) {
        let stoppedAction = parkingAction.copy(withEndDate: Date())
        networkService.requestModel(ParkingActionsServiceRequest.stopParkingAction(parkingAction: stoppedAction)) {
            completion?($0)
        }
    }
}

private extension ParkingActionsService {

    private func getActions(for user: User, predicate: @escaping (ParkingAction) -> Bool,
                            completion externalCompletion: ((ParkerlyServiceOperation<[ParkingAction]>) -> Void)?) {
        guard let userId = user.id else {
            os_log("Cannot fetch actions without user id")
            externalCompletion?(ParkerlyServiceOperation.failed(.malformedRequest))
            return
        }

        let internalCompletion: (ParkerlyServiceOperation<[ParkingAction]>) -> Void = { operation in
            switch operation {
            case .completed(let actions):
                let filteredActions = actions.filter(predicate)
                DispatchQueue.main.async {
                    externalCompletion?(ParkerlyServiceOperation.completed(filteredActions))
                }
            case .failed(_):
                DispatchQueue.main.async {
                    externalCompletion?(operation)
                }
            }
        }

        networkService.requestArray(ParkingActionsServiceRequest.getActiveActions(userId: userId),
            completion: internalCompletion);
    }
}