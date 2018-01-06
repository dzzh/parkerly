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

enum UserServiceRequest {
    case createUser(user: User)
    case getUsers
    case getUser(id: String)
    case editUser(user: User)
    case deleteUser(id: String)
}

extension UserServiceRequest: NetworkRequestType {

    var servicePath: String? {
        return "/users"
    }

    var requestPath: String? {
        switch self {
        case .createUser, .getUsers:
            return nil
        case .getUser(let id), .deleteUser(let id):
            return id
        case .editUser(let user):
            guard let id = user.id else {
                return nil
            }
            return id
        }
    }

    var method: HttpMethod {
        switch self {
        case .createUser(_): return .post
        case .getUsers, .getUser(_): return .get
        case .editUser(_): return .patch
        case .deleteUser(_): return .delete
        }
    }

    func urlRequest(_ requestFactory: RequestFactoryType) -> URLRequest? {
        let body: Data?
        switch self {
        case .createUser(let user), .editUser(let user):
            guard let _body = user.copyWithoutId.encoded else {
                os_log("Couldn't encode user %@", user.debugDescription)
                return nil
            }
            body = _body
        case .getUsers, .getUser(_), .deleteUser:
            body = nil
        }
        return requestFactory.request(with: fullPath, method: method, body: body)
    }
}

public protocol UserServiceType: ParkerlyServiceType {

    var currentUser: User? { get }

    func get(completion: ((ParkerlyServiceOperation<[User]>) -> Void)?)

    func get(_ id: NetworkId, completion: ((ParkerlyServiceOperation<User>) -> Void)?)

    func edit(_ user: User, completion: ((ParkerlyServiceOperation<User>) -> Void)?)

    func delete(_ id: NetworkId, completion: ((ParkerlyServiceOperation<Void>) -> Void)?)

    func login(_ user: User, completion: ((ParkerlyServiceOperation<User>) -> Void)?)

    func logout(completion: ((ParkerlyServiceOperation<Void>) -> Void)?)

    func register(_ user: User, completion: ((ParkerlyServiceOperation<User>) -> Void)?)
}

public class UserService {

    private static let userDefaultsCurrentUserKey = "currentUserKey"

    private let networkService: NetworkServiceType

    init(networkService: NetworkServiceType) {
        self.networkService = networkService
        currentUser = fetchCurrentUserFromStorage()
    }

    public var currentUser: User? {
        didSet {
            saveCurrentUserToStorage()
        }
    }
}

extension UserService: UserServiceType {

    public func get(completion: ((ParkerlyServiceOperation<[User]>) -> Void)?) {
        networkService.requestArray(UserServiceRequest.getUsers) { operation in
            DispatchQueue.main.async {
                completion?(operation)
            }
        };
    }

    public func get(_ id: NetworkId, completion: ((ParkerlyServiceOperation<User>) -> Void)?) {
        networkService.requestModel(UserServiceRequest.getUser(id: id)) { operation in
            DispatchQueue.main.async {
                completion?(operation)
            }
        };
    }

    public func edit(_ user: User, completion externalCompletion: ((ParkerlyServiceOperation<User>) -> Void)?) {

        let internalCompletion: (ParkerlyServiceOperation<User>) -> Void = { [weak self] operation in
            DispatchQueue.main.async {
                if case let .completed(updatedUser) = operation, updatedUser.id == self?.currentUser?.id {
                    self?.currentUser = updatedUser
                }
                externalCompletion?(operation)
            }
        }

        networkService.requestModel(UserServiceRequest.editUser(user: user.copyWithoutId), completion: internalCompletion)
    }

    public func delete(_ id: NetworkId, completion: ((ParkerlyServiceOperation<Void>) -> Void)?) {
        networkService.requestOperation(UserServiceRequest.deleteUser(id: id)) { operation in
            DispatchQueue.main.async {
                completion?(operation)
            }
        };
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
        create(user) { [weak self] operation in
            guard let `self` = self else {
                completion?(ParkerlyServiceOperation.failed(.internalError(description: "memory leak")))
                return
            }
            switch operation {
            case .completed(let id):
                self.get(id) { operation in
                    completion?(operation)
                    if case let .completed(user) = operation {
                        self.notify(name: UserServiceNotification.didRegister.name, returnValue: user)
                    }
                }
            case .failed(let error):
                completion?(ParkerlyServiceOperation.failed(error))
            }
        }
    }
}

private extension UserService {

    func create(_ user: User, completion: ((ParkerlyServiceOperation<NetworkId>) -> Void)?) {
        networkService.requestId(UserServiceRequest.createUser(user: user.copyWithoutId)) { operation in
            DispatchQueue.main.async {
                completion?(operation)
            }
        };
    }

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
