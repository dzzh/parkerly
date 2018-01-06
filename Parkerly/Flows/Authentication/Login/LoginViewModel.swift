//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import ParkerlyCore
import os.log

protocol LoginViewModelDelegate: class {

    func wantsToRegister()
}

class LoginViewModel: TableWithOptionalButtonViewModel {

    private let userService: UserServiceType
    private let dataSource: TableSectionDataSourceType

    weak var delegate: LoginViewModelDelegate?

    init(userService: UserServiceType, dataSource: TableSectionDataSourceType, actionButtonTitle: String?) {
        self.userService = userService
        self.dataSource = dataSource
        super.init(sections: [dataSource], actionButtonTitle: actionButtonTitle)
    }

    // MARK: - TableWithOptionalButtonViewModel

    override func didSelectRow(at indexPath: IndexPath) {
        guard let user = dataSource.object(for: indexPath.row) as? User, user.id != nil else {
            os_log("Invalid user or missing user id at path %@", String(describing: indexPath))
            return
        }
        userService.login(user, completion: nil)
    }

    override func didTapActionButton() {
        delegate?.wantsToRegister()
    }
}
