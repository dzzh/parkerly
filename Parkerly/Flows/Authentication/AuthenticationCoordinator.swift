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

    // TODO: introduce proper loading state when fetching the data
    override func start() {
        let loginDataSection = LoginSectionDataSource(userService: userService)
        let loginViewModel = LoginViewModel(userService: userService, dataSource: loginDataSection, actionButtonTitle: "Add new user")
        loginViewModel.delegate = self
        let loginViewController = TableWithOptionalButtonViewController(viewModel: loginViewModel)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.navigationBar.barTintColor = .white
        navigationController.pushViewController(loginViewController, animated: false)

        guard let container = presentationContext as? ContainerViewController else {
            os_log("Authentication flow can only be presented in container context") //TODO: proper error handling
            return
        }

        loginDataSection.reload { [weak self] error in
            guard let `self` = self else {
                os_log("already deallocated")
                return
            }

            if error == nil {
                container.containedViewController = self.navigationController
            } else {
                // TODO: error handling
            }
        }
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