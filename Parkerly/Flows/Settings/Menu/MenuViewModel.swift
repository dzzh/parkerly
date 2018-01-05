//
// Created by Zmicier Zaleznicenka on 5/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log

protocol MenuViewModelDelegate: class {

    func wantsProfile()

    func wantsHistory()

    func logout()

    func closeMenu()
}

class MenuViewModel: TableWithOptionalButtonViewModel {

    private let dataSource = MenuSectionDataSource()
    private weak var delegate: MenuViewModelDelegate?

    // MARK: - Initialization

    init(delegate: MenuViewModelDelegate) {
        self.delegate = delegate
        super.init(sections: [dataSource], actionButtonTitle: nil)
    }

    // MARK: - TableWithOptionalButtonViewModel

    override func didSelectRow(at indexPath: IndexPath) {
        guard let menuOption = dataSource.object(for: indexPath.row) as? MenuOption else {
            os_log("No menu option for row %d", indexPath.row)
            return
        }
        handle(menuOption)
    }
}

private extension MenuViewModel {

    func handle(_ menuOption: MenuOption) {
        switch menuOption {
        case .profile:
            delegate?.wantsProfile()
        case .history:
            delegate?.wantsHistory()
        case .logout:
             delegate?.logout()
        case .closeMenu:
            delegate?.closeMenu()
        }
    }
}
