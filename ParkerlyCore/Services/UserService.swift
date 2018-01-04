//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

public enum UserServiceNotification: String, ParkerlyServiceNotification {
    case didLogin = "userServiceNotificationNameDidLogin"
    case didRegister = "userServiceNotificationNameDidRegister"
    case didLogout = "userServiceNotificationNameDidLogout"
}

public protocol UserServiceType: ParkerlyServiceType {

    // TODO: save/load from NSUserDefaults
    var currentUser: User? { get }

    func login(_ userId: String, completion: ((ParkerlyServiceOperation<User>) -> Void)?)

    func register(_ user: User, completion: ((ParkerlyServiceOperation<User>) -> Void)?)

    func logout(completion: ((ParkerlyServiceOperation<Void>) -> Void)?)
}

public class UserService {

    public var currentUser: User?
}

extension UserService: UserServiceType {

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

    public func logout(completion: ((ParkerlyServiceOperation<Void>) -> Void)?) {
        currentUser = nil
        notify(name: UserServiceNotification.didLogout.name)
    }
}
