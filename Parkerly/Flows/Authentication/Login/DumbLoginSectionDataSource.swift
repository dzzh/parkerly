//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import ParkerlyCore
import os.log

class DumbLoginSectionDataSource: TableSectionDataSource {

    private(set) var numberOfRows: Int = 2

    var header: String? = "Users"

    func object(for row: Int) -> Any? {
        switch row {
        case 0: return User(id: "user0", firstName: "name1", lastName: "surname1", username: "user1")
        case 1: return User(id: "user1", firstName: "name2", lastName: "surname2", username: "user2")
        default:
            os_log("Unexpected row %d", row)
            return nil
        }
    }

    func cellData(for row: Int) -> TableCellDataType? {
        return object(for: row) as? TableCellDataType
    }
}

extension User: TableCellDataType {

    var title: String {
        return username
    }
}