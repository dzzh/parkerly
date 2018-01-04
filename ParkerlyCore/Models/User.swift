//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

public struct User {

    public let firstName: String
    public let lastName: String
    public let username: String

    public init(firstName: String, lastName: String, username: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
    }
}
