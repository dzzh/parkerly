//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

public extension NotificationCenter {

    func post(name: Notification.Name, object: Any?, serviceReturnValue: Any) {
        var userInfo: [AnyHashable: Any] = [:]
        userInfo[Notification.serviceReturnValueKey] = serviceReturnValue
        post(Notification(name: name, object: object, userInfo: userInfo))
    }
}

public extension Notification {

    static let serviceReturnValueKey = "parkerlyServiceReturnValueKey"

    var serviceReturnValue: Any? {
        return self.userInfo?[Notification.serviceReturnValueKey]
    }
}
