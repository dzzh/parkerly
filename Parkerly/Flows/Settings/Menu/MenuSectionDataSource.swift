//
// Created by Zmicier Zaleznicenka on 5/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

enum MenuOption: Int {
    case profile = 0
    case history
    case vehicles
    case logout

    static var all: [MenuOption] = [.profile, .history, .vehicles, .logout]

    var title: String {
        switch self {
        case .history: return "History"
        case .logout: return "Logout"
        case .profile: return "Profile"
        case .vehicles: return "Vehicles"
        }
    }

    static func option(for row: Int) -> MenuOption? {
        guard let option = MenuOption(rawValue: row) else {
            os_log("Unexpected row %d", row)
            return nil
        }
        return option
    }
}

extension MenuOption: TableCellDataType {

}

class MenuSectionDataSource: TableSectionDataSource {

    override var numberOfRows: Int {
        return MenuOption.all.count
    }

    override var header: String? {
        return nil
    }

    override func object(for row: Int) -> Any? {
        return MenuOption.option(for: row)
    }

    override func cellData(for row: Int) -> TableCellDataType? {
        return object(for: row) as? MenuOption
    }
}
