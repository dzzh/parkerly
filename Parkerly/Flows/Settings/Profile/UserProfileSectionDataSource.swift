//
// Created by Zmicier Zaleznicenka on 6/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log
import ParkerlyCore

class UserProfileSectionDataSource: TableSectionDataSource {

    // TODO: add actual editing, change to var
    let editedUser: User

    init(user: User) {
        self.editedUser = user.copy(withId: user.id)
    }

    override var numberOfRows: Int {
        return 3
    }

    override var header: String? {
        return "Profile"
    }

    override func object(for row: Int) -> Any? {
        return nil
    }

    override func cellData(for row: Int) -> TableCellDataType? {
        switch row {
            case 0: return SimpleCellDataType(title: editedUser.username, subtitle: "Username")
            case 1: return SimpleCellDataType(title: editedUser.firstName, subtitle: "First name")
            case 2: return SimpleCellDataType(title: editedUser.lastName, subtitle: "Last name")
            default:
                os_log("unexpected row %d", row)
                return nil
        }
    }
}
