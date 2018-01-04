//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import ParkerlyCore

class DumbLoginDataSection: TableSectionDataSource {

    private(set) var numberOfRows: Int = 2

    var header: String? = "Users"

    func cellData(for row: Int) -> TableCellDataType? {
        switch row {
        case 0: return User(firstName: "name1", lastName: "surname1", username: "user1")
        case 1: return User(firstName: "name2", lastName: "surname2", username: "user2")
        default: fatalError("oops")
        }
    }
}

extension User: TableCellDataType {

    var title: String {
        return username
    }
}