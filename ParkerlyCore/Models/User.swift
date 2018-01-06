//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

public struct User: ParkerlyModel {

    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case username = "userName"
    }

    public let id: NetworkId?
    public let firstName: String
    public let lastName: String
    public let username: String

    public init(id: NetworkId?, firstName: String, lastName: String, username: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
    }

    public var copyWithoutId: User {
        return User(id: nil, firstName: firstName, lastName: lastName, username: username)
    }

    public func copy(withId id: NetworkId?) -> User {
        return User(id: id, firstName: firstName, lastName: lastName, username: username)
    }
}
