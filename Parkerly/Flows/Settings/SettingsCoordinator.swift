//
// Created by Zmicier Zaleznicenka on 5/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log
import ParkerlyCore
import UIKit

enum SettingsCoordinatorScreen {
    case history
    case menu
    case profile
    case vehicles
}

class SettingsCoordinator: FlowCoordinator {

    // MARK: - State

    private let userService: UserServiceType

    private let initialScreen: SettingsCoordinatorScreen
    private let presentationMode: CoordinatorPresentationMode
    private var navigationController: UINavigationController?

    // MARK: - Initialization

    init(userService: UserServiceType, initialScreen: SettingsCoordinatorScreen,
         presentationMode: CoordinatorPresentationMode, presentationContext: UIViewController,
         delegate: FlowCoordinatorDelegate? = nil) {
        self.userService = userService
        self.initialScreen = initialScreen
        self.presentationMode = presentationMode
        super.init(presentationContext: presentationContext, delegate: delegate)
    }

    // MARK: - FlowCoordinator

    override func start() {
        let viewController: UIViewController
        switch initialScreen {
        case .history:
            viewController = historyScreen
        case .menu:
            viewController = menuScreen
        case .profile:
            viewController = profileScreen
        case .vehicles:
            viewController = vehiclesScreen
        }
        present(viewController)
    }

    override func cleanup(completion: () -> Void) {
        completion()
    }
}

extension SettingsCoordinator: MenuViewModelDelegate {

    func wantsProfile() {
        print("wants profile")
    }

    func wantsHistory() {
        print("wants history")
    }

    func logout() {
        presentationContext?.dismiss(animated: true) { [weak self] in
            guard let `self` = self else {
                os_log("already deallocated")
                return
            }
            self.userService.logout { [weak self] operation in
                guard let `self` = self else {
                    os_log("already deallocated")
                    return
                }

                switch operation {
                case .completed:
                    self.delegate?.flowCoordinatorDidComplete(self)
                case .failed:
                    break // TODO: error handling
                }
            }
        }
    }

    func closeMenu() {
        presentationContext?.dismiss(animated: true) { [weak self] in
            guard let `self` = self else {
                os_log("already deallocated")
                return
            }
            self.delegate?.flowCoordinatorDidComplete(self)
        }
    }
}

private extension SettingsCoordinator {

    var menuScreen: UIViewController {
        let viewModel = MenuViewModel(delegate: self)
        let viewController = TableWithOptionalButtonViewController(viewModel: viewModel)
        viewController.title = "Menu"
        return viewController
    }

    var profileScreen: UIViewController {
        return UIViewController()
    }

    var historyScreen: UIViewController {
        return UIViewController()
    }

    var vehiclesScreen: UIViewController {
        return UIViewController()
    }

    func present(_ viewController: UIViewController) {
        switch presentationMode {
        case .container:
            if let navigationController = navigationController {
                navigationController.pushViewController(viewController, animated: true)
            } else {
                guard let container = presentationContext as? ContainerViewController else {
                    os_log("presentation context is not a container")
                    return
                }
                navigationController = UINavigationController()
                navigationController?.pushViewController(viewController, animated: false)
                container.containedViewController = navigationController!
            }
        case .modal:
            if let navigationController = navigationController {
                navigationController.pushViewController(viewController, animated: true)
            } else {
                navigationController = UINavigationController()
                navigationController?.pushViewController(viewController, animated: false)
                presentationContext?.present(navigationController!, animated: true)
            }
        case .navigation:
            guard let providedNavigationController = presentationContext as? UINavigationController else {
                os_log("presentation context is not a navigation controller")
                return
            }
            providedNavigationController.pushViewController(viewController, animated: true)
        }
    }
}
