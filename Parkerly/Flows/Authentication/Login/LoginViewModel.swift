//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import ParkerlyCore

protocol LoginViewModelDelegate: class {

    func didLogin(with user: User)

    func wantsToRegister()
}

class LoginViewModel: TableWithOptionalButtonViewModel {

    weak var delegate: LoginViewModelDelegate?

    // MARK: - Interface

    func didSelect(_ user: User) {
        delegate?.didLogin(with: user)
    }

    // MARK: - TableWithOptionalButtonViewModel

    override func handleActionButtonTap() {
        delegate?.wantsToRegister()
    }
}
