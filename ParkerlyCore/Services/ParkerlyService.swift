//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

public enum ParkerlyServiceOperation<T> {
    case completed(T)
    case failed(ParkerlyError)
}

// MARK: - ParkerlyServiceNotification

public protocol ParkerlyServiceNotification {

    var rawValue: String { get }

    var name: Notification.Name { get }
}

public extension ParkerlyServiceNotification {

    var name: Notification.Name {
        return Notification.Name(rawValue: rawValue)
    }
}

// MARK: - ParkerlyServiceType

public protocol ParkerlyServiceType {

    func notify(name: Notification.Name, returnValue: Any?)
}

extension ParkerlyServiceType {

    public func notify(name: Notification.Name, returnValue: Any? = nil) {
        if let returnValue = returnValue {
            NotificationCenter.default.post(name: name, object: self, serviceReturnValue: returnValue)
        } else {
            NotificationCenter.default.post(name: name, object: self)
        }
    }
}

// MARK: - ParkerlyService

public class ParkerlyService: ParkerlyServiceType {

    let crudService: CrudServiceType

    init(crudService: CrudServiceType) {
        self.crudService = crudService
    }
}



