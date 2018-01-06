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

// TODO: better screen management, ensure coordinator disposes after popping initial vc
class SettingsCoordinator: FlowCoordinator {

    // MARK: - State

    private let userService: UserServiceType
    private let parkingActionsService: ParkingActionsServiceType

    private let initialScreen: SettingsCoordinatorScreen
    private let presentationMode: CoordinatorPresentationMode
    private var navigationController: UINavigationController?

    // MARK: - Initialization

    init(userService: UserServiceType, parkingActionsService: ParkingActionsServiceType,
         initialScreen: SettingsCoordinatorScreen, presentationMode: CoordinatorPresentationMode,
         presentationContext: UIViewController, delegate: FlowCoordinatorDelegate? = nil) {
        self.userService = userService
        self.parkingActionsService = parkingActionsService
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
        present(profileScreen)
    }

    func wantsHistory() {
        present(historyScreen)
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
                    self.presentationContext?.presentError(.userError(userMessage: "Couldn't logout"))
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

extension SettingsCoordinator: UserProfileViewModelDelegate {

    func didSaveUser() {
        dismissPresented()
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
        guard userService.currentUser != nil,
            let viewModel = UserProfileViewModel(userService: userService, delegate: self) else {
            os_log("not logged in")
            return UIViewController()
        }

        let viewController = TableWithOptionalButtonViewController(viewModel: viewModel)
        return viewController
    }

    var historyScreen: UIViewController {
        guard let user = userService.currentUser else {
            os_log("not logged in")
            return UIViewController()
        }

        let historySection = ParkingHistorySectionDataSource(parkingActionsService: parkingActionsService, user: user)
        let viewModel = TableWithOptionalButtonViewModel(sections: [historySection], actionButtonTitle: nil)
        let viewController = TableWithOptionalButtonViewController(viewModel: viewModel)
        return viewController
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

    // TODO: better implementation, track screen types
    func dismissPresented() {
        switch presentationMode {
        case .container:
            if let navigationController = navigationController, navigationController.viewControllers.count > 1 {
                navigationController.popViewController(animated: true)
            } else {
                // TODO: dismiss coordinator
            }
        case .modal:
            if let navigationController = navigationController, navigationController.viewControllers.count > 1 {
                navigationController.popViewController(animated: true)
            } else {
                // TODO: dismiss coordinator
            }
        case .navigation:
            guard let providedNavigationController = presentationContext as? UINavigationController else {
                os_log("presentation context is not a navigation controller")
                return
            }

            // TODO: don't dismiss what you don't own, count your stack
            providedNavigationController.popViewController(animated: true)
        }
    }
}
