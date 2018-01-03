//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

public extension Collection where Index: BinaryInteger {
    subscript (safe index: Index) -> Self.Iterator.Element? {
        guard startIndex <= index && index < endIndex else {
            return nil
        }
        return self[index]
    }
}
