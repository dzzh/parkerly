//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import os.log
import ParkerlyCore

protocol AuthenticationCoordinatorDelegate: class {

    func didLogin(with user: User)
}

class AuthenticationCoordinator: FlowCoordinator {

    let navigationController = UINavigationController()
    weak var delegate: AuthenticationCoordinatorDelegate?

    // MARK: - FlowCoordinator

    override func start() {
        let loginDataSection = DumbLoginDataSection()
        let loginViewModel = LoginViewModel(sections: [loginDataSection], actionButtonTitle: "Add new user")
        loginViewModel.delegate = self
        let loginViewController = TableWithOptionalButtonViewController(viewModel: loginViewModel)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(loginViewController, animated: false)

        guard let container = presentationContext as? ContainerViewController else {
            os_log("Authentication flow can only be presented in container context") //TODO proper error handling
            return
        }

        container.containedViewController = navigationController
    }
}

extension AuthenticationCoordinator: LoginViewModelDelegate {

    func didLogin(with user: User) {
        delegate?.didLogin(with: user)
    }

    func wantsToRegister() {
        let registrationViewModel = RegistrationViewModel(delegate: self)
        let registrationViewController = RegistrationViewController(viewModel: registrationViewModel)
        navigationController.pushViewController(registrationViewController, animated: true)
    }
}

extension AuthenticationCoordinator: RegistrationViewModelDelegate {

    func didRegisterNewUser() {
        navigationController.popViewController(animated: true)
    }
}