//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

public enum UserServiceNotification: String, ParkerlyServiceNotification {
    case didLogin = "userServiceNotificationNameDidLogin"
    case didRegister = "userServiceNotificationNameDidRegister"
    case didLogout = "userServiceNotificationNameDidLogout"
}

private struct GetUsersRequest: NetworkRequestType {

    let servicePath: String = User.servicePath
    let requestPath: String? = nil
    let method: HttpMethod = .get

    func urlRequest(_ requestFactory: RequestFactoryType) -> URLRequest? {
        return requestFactory.request(with: fullPath, method: method, body: nil)
    }
}

// MARK: - UserService

public protocol UserServiceType: ParkerlyServiceType {

    var currentUser: User? { get }

    func delete(_ user: User, completion: ((ParkerlyServiceOperation<Void>) -> Void)?)

    func edit(_ user: User, completion: ((ParkerlyServiceOperation<User>) -> Void)?)

    func getUser(_ id: NetworkId, completion: ((ParkerlyServiceOperation<User>) -> Void)?)

    func getUsers(completion: ((ParkerlyServiceOperation<[User]>) -> Void)?)

    func login(_ user: User, completion: ((ParkerlyServiceOperation<User>) -> Void)?)

    func logout(completion: ((ParkerlyServiceOperation<Void>) -> Void)?)

    func register(_ user: User, completion: ((ParkerlyServiceOperation<User>) -> Void)?)
}

public class UserService: ParkerlyService {

    private static let userDefaultsCurrentUserKey = "currentUserKey"

    private let modelRequest = NetworkModelRequest<User>.self

    override init(crudService: CrudServiceType) {
        super.init(crudService: crudService)
        currentUser = fetchCurrentUserFromStorage()
    }

    public var currentUser: User? {
        didSet {
            saveCurrentUserToStorage()
        }
    }
}

extension UserService: UserServiceType {

    public func delete(_ user: User, completion: ((ParkerlyServiceOperation<Void>) -> Void)?) {
        guard user.id != nil else {
            os_log("Cannot delete user without id")
            completion?(ParkerlyServiceOperation.failed(.malformedRequest))
            return
        }

        let deleteRequest = modelRequest.deleteModel(user)
        crudService.deleteModel(request: deleteRequest, completion: completion)
    }

    public func edit(_ user: User, completion: ((ParkerlyServiceOperation<User>) -> Void)?) {
        guard user.id != nil else {
            os_log("Cannot edit user without id")
            completion?(ParkerlyServiceOperation.failed(.malformedRequest))
            return
        }

        let editRequest = modelRequest.editModel(user)
        crudService.editModel(request: editRequest) { [weak self] (operation: ParkerlyServiceOperation<User>) -> Void in
            if case let .completed(updatedUser) = operation, updatedUser.id == self?.currentUser?.id {
                self?.currentUser = updatedUser
            }
            completion?(operation)
        }
    }

    public func getUser(_ id: NetworkId, completion: ((ParkerlyServiceOperation<User>) -> Void)?) {
        let getRequest = modelRequest.getModel(modelId: id, userId: id)
        crudService.getModel(request: getRequest, completion: completion)
    }

    public func getUsers(completion: ((ParkerlyServiceOperation<[User]>) -> Void)?) {
        let getRequest = GetUsersRequest()
        crudService.getModels(request: getRequest, completion: completion)
    }

    public func login(_ user: User, completion: ((ParkerlyServiceOperation<User>) -> Void)?) {
        currentUser = user
        completion?(.completed(currentUser!))
        notify(name: UserServiceNotification.didLogin.name, returnValue: currentUser)
    }

    public func logout(completion: ((ParkerlyServiceOperation<Void>) -> Void)?) {
        currentUser = nil
        completion?(ParkerlyServiceOperation.completed(()))
        notify(name: UserServiceNotification.didLogout.name)
    }

    public func register(_ user: User, completion: ((ParkerlyServiceOperation<User>) -> Void)?) {
        let createRequest = modelRequest.createModel(user.copyWithoutId)
        let getRequest: (NetworkId) -> NetworkRequestType? = { [weak self] id in
            return self?.modelRequest.getModel(modelId: id, userId: id)
        }
        crudService.createModel(createRequest: createRequest, getRequest: getRequest) {
            [weak self] (operation: ParkerlyServiceOperation<User>) -> Void in

            guard let `self` = self else {
                completion?(ParkerlyServiceOperation.failed(.internalError(description: "memory leak")))
                return
            }

            switch operation {
            case .completed(let user):
                completion?(operation)
                self.notify(name: UserServiceNotification.didRegister.name, returnValue: user)
            case .failed(let error):
                completion?(ParkerlyServiceOperation.failed(error))
            }
        }
    }
}

private extension UserService {

    func saveCurrentUserToStorage() {
        UserDefaults.standard.set(currentUser?.encodedString, forKey: UserService.userDefaultsCurrentUserKey)
    }

    func fetchCurrentUserFromStorage() -> User? {
        guard let json = UserDefaults.standard.string(forKey: UserService.userDefaultsCurrentUserKey) else {
            return nil
        }
        return User.decode(from: json)
    }
}
