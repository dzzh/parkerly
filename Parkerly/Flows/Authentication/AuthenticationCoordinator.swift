//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import os.log
import ParkerlyCore

class AuthenticationCoordinator: FlowCoordinator {

    private let navigationController = UINavigationController()

    private let userService: UserServiceType

    // MARK: Initialization

    init(userService: UserServiceType, presentationContext: UIViewController) {
        self.userService = userService
        super.init(presentationContext: presentationContext)
    }

    // MARK: - FlowCoordinator

    override func start() {
        let loginDataSection = DumbLoginSectionDataSource()
        let loginViewModel = LoginViewModel(userService: userService, dataSource: loginDataSection, actionButtonTitle: "Add new user")
        loginViewModel.delegate = self
        let loginViewController = TableWithOptionalButtonViewController(viewModel: loginViewModel)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.navigationBar.barTintColor = .white
        navigationController.pushViewController(loginViewController, animated: false)

        guard let container = presentationContext as? ContainerViewController else {
            os_log("Authentication flow can only be presented in container context") //TODO proper error handling
            return
        }

        container.containedViewController = navigationController
    }
}

extension AuthenticationCoordinator: LoginViewModelDelegate {

    func wantsToRegister() {
        let registrationViewModel = RegistrationViewModel(userService: userService, delegate: self)
        let registrationViewController = RegistrationViewController(viewModel: registrationViewModel)
        navigationController.pushViewController(registrationViewController, animated: true)
    }
}

extension AuthenticationCoordinator: RegistrationViewModelDelegate {

    func didRegisterNewUser() {
        guard navigationController.topViewController is RegistrationViewController else {
            os_log("Registration screen is already removed")
            return
        }
        navigationController.popViewController(animated: true)
    }
}