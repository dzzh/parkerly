//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

public struct Vehicle {

    public let id: String?
    public let userId: String
    public let title: String
    public let vrn: String

    public init(id: String?, userId: String, title: String, vrn: String) {
        self.id = id
        self.userId = userId
        self.title = title
        self.vrn = vrn
    }
}
