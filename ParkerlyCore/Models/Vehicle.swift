//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

public struct Vehicle: ParkerlyModel {

    public let id: NetworkId?
    public let userId: NetworkId
    public let title: String
    public let vrn: String

    public init(id: NetworkId?, userId: NetworkId, title: String, vrn: String) {
        self.id = id
        self.userId = userId
        self.title = title
        self.vrn = vrn
    }

    public var copyWithoutId: Vehicle {
        return Vehicle(id: nil, userId: userId, title: title, vrn: vrn)
    }

    public func copy(withId id: NetworkId?) -> Vehicle {
        return Vehicle(id: id, userId: userId, title: title, vrn: vrn)
    }
}
