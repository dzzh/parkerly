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

// TODO: Clearly, this is not the API design the production app should aim for.
// I deliberately don't address authentication and data integrity issues to simplify services implementations.
public protocol UserServiceType: ParkerlyServiceType {

    var currentUser: User? { get }

    func get(completion: ((ParkerlyServiceOperation<[User]>) -> Void)?)

    func login(_ userId: String, completion: ((ParkerlyServiceOperation<User>) -> Void)?)

    func register(_ user: User, completion: ((ParkerlyServiceOperation<User>) -> Void)?)

    func edit(_ user: User, completion: ((ParkerlyServiceOperation<Void>) -> Void)?)

    func logout(completion: ((ParkerlyServiceOperation<Void>) -> Void)?)
}

public class UserService {

    private static let userDefaultsCurrentUserKey = "currentUserKey"

    init() {
        currentUser = fetchCurrentUserFromStorage()
    }

    public var currentUser: User? {
        didSet {
            saveCurrentUserToStorage()
        }
    }
}

// TODO: implement edit, connect to network service
extension UserService: UserServiceType {

    public func get(completion: ((ParkerlyServiceOperation<[User]>) -> Void)?) {
        let users: [User] = [
            User(id: "user1", firstName: "firstName1", lastName: "lastName1", username: "username1"),
            User(id: "user2", firstName: "firstName2", lastName: "lastName2", username: "username2")
        ]
        completion?(ParkerlyServiceOperation.completed(users))
    }

    public func login(_ userId: String, completion: ((ParkerlyServiceOperation<User>) -> Void)?) {
        currentUser = User(id: "xxx", firstName: "xxx", lastName: "xxx", username: "xxx")
        completion?(.completed(currentUser!))
        notify(name: UserServiceNotification.didLogin.name, returnValue: currentUser)
    }

    public func register(_ user: User, completion: ((ParkerlyServiceOperation<User>) -> Void)?) {
        let registeredUser = User(id: "yyy", firstName: "yyy", lastName: "yyy", username: "yyy")
        completion?(.completed(registeredUser))
        notify(name: UserServiceNotification.didRegister.name, returnValue: registeredUser)
    }

    public func edit(_ user: User, completion: ((ParkerlyServiceOperation<Void>) -> Void)?) {
        // TODO: implement
        os_log("Not implemented")
        completion?(.completed(()))
    }

    public func logout(completion: ((ParkerlyServiceOperation<Void>) -> Void)?) {
        currentUser = nil
        notify(name: UserServiceNotification.didLogout.name)
    }
}

private extension UserService {

    func saveCurrentUserToStorage() {
        UserDefaults.standard.set(currentUser?.encoded, forKey: UserService.userDefaultsCurrentUserKey)
    }

    func fetchCurrentUserFromStorage() -> User? {
        guard let json = UserDefaults.standard.string(forKey: UserService.userDefaultsCurrentUserKey) else {
            return nil
        }
        return User.decode(from: json)
    }
}
