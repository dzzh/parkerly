//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

public struct Vehicle: ParkerlyModel {

    public static let servicePath: String = "/vehicles"

    public let id: NetworkId?
    public let userId: NetworkId
    public let title: String
    public let vrn: String
    public let isDefault: Bool

    public init(id: NetworkId?, userId: NetworkId, title: String, vrn: String, isDefault: Bool) {
        self.id = id
        self.userId = userId
        self.title = title
        self.vrn = vrn
        self.isDefault = isDefault
    }

    public var copyWithoutId: Vehicle {
        return Vehicle(id: nil, userId: userId, title: title, vrn: vrn, isDefault: isDefault)
    }

    public func copy(withId id: NetworkId?) -> Vehicle {
        return Vehicle(id: id, userId: userId, title: title, vrn: vrn, isDefault: isDefault)
    }

    public func copy(withDefault isDefault: Bool) -> Vehicle {
        return Vehicle(id: id, userId: userId, title: title, vrn: vrn, isDefault: isDefault)
    }

    // MARK: - Helpers

    public static var randomTitle: String {
        let titles = ["BMW", "Harley-Davidson", "Indian", "Ducati", "Yamaha", "Aprilia"]
        let randomNumber = Int(arc4random_uniform(UInt32(titles.count)))
        return titles[randomNumber]
    }

    public static var randomVrn: String {
        let symbols = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        var result = ""

        for i in 0..<6 {
            let randomNumber = Int(arc4random_uniform(UInt32(symbols.count)))
            let index = symbols.index(symbols.startIndex, offsetBy: randomNumber)
            let newCharacter = symbols[index]
            result += String(newCharacter)
            if i == 1 || i == 3 {
                result += "-"
            }
        }

        return result
    }
}
