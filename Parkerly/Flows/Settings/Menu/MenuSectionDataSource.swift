//
// Created by Zmicier Zaleznicenka on 5/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

enum MenuOption {
    case profile
    case history
    case logout
    case closeMenu

    var title: String {
        switch self {
        case .profile: return "Profile N/A"
        case .history: return "History N/A"
        case .logout: return "Logout"
        case .closeMenu: return "Close menu"
        }
    }

    static func option(for row: Int) -> MenuOption? {
        switch row {
        case 0: return .profile
        case 1: return .history
        case 2: return .logout
        case 3: return .closeMenu
        default:
            os_log("Unexpected row %d", row)
            return nil
        }
    }
}

extension MenuOption: TableCellDataType {

}

class MenuSectionDataSource: TableSectionDataSource {

    override var numberOfRows: Int {
        return 4
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
