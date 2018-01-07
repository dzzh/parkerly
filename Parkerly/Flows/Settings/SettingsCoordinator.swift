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
    private let parkingActionsService: ParkingActionsServiceType
    private let vehiclesService: VehiclesServiceType

    private let initialScreen: SettingsCoordinatorScreen
    private var navigationController: UINavigationController?

    // MARK: - Initialization

    init(userService: UserServiceType, parkingActionsService: ParkingActionsServiceType,
         vehiclesService: VehiclesServiceType, initialScreen: SettingsCoordinatorScreen,
         presentationContext: UIViewController, delegate: FlowCoordinatorDelegate? = nil) {
        self.userService = userService
        self.parkingActionsService = parkingActionsService
        self.vehiclesService = vehiclesService
        self.initialScreen = initialScreen
        super.init(presentationContext: presentationContext, delegate: delegate)
    }

    // MARK: - FlowCoordinator

    override func start() {
        let viewController: UIViewController
        switch initialScreen {
        case .history:
            viewController = historyScreen(isInitial: true)
        case .menu:
            viewController = menuScreen
        case .profile:
            viewController = profileScreen
        case .vehicles:
            viewController = vehiclesScreen(isInitial: true)
        }
        present(viewController)
    }

    override func cleanup(completion: () -> Void) {
        presentationContext?.dismiss(animated: true)
        super.cleanup(completion: completion)
    }
}

extension SettingsCoordinator: MenuViewModelDelegate {

    func wantsProfile() {
        present(profileScreen)
    }

    func wantsHistory() {
        present(historyScreen(isInitial: false))
    }

    func wantsVehicles() {
        present(vehiclesScreen(isInitial: false))
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
        dismissPresentedViewController()
    }
}

extension SettingsCoordinator: VehiclesViewModelDelegate {

    func wantsVehicleDetails(_ vehicle: Vehicle) {
        guard let vehicleDetailsViewModel = VehicleDetailsViewModel(
            vehiclesService: vehiclesService, vehicle: vehicle, delegate: self) else {
            os_log("Couldn't create a view model")
            return
        }
        let viewController = TableWithOptionalButtonViewController(viewModel: vehicleDetailsViewModel)
        guard let navigationController = navigationController else {
            os_log("Expected navigation controller")
            return
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    func wantsNewVehicle(for user: User) {
        guard let userId = user.id else {
            os_log("No user id")
            return
        }

        vehiclesService.getVehicles(for: user) { [weak self] operation in
            let hasVehicles: Bool
            switch operation {
            case .completed(let vehicles):
                hasVehicles = !vehicles.isEmpty
            case .failed(_):
                hasVehicles = true
            }
            let newVehicle = Vehicle(id: nil, userId: userId, title: "New vehicle", vrn: "XX-YY-ZZ", isDefault: !hasVehicles)
            self?.wantsVehicleDetails(newVehicle)
        }
    }
}

extension SettingsCoordinator: VehicleDetailsViewModelDelegate {

    func didSaveVehicle() {
        guard let navigationController = navigationController,
            navigationController.viewControllers.count > 1 else {
            os_log("Expected navigation controller")
            return
        }

        navigationController.popViewController(animated: true)
    }
}

extension SettingsCoordinator: CloseableViewControllerDelegate {

    func close() {
        dismissPresentedViewController()
    }
}

private extension SettingsCoordinator {

    var menuScreen: UIViewController {
        let viewModel = MenuViewModel(delegate: self)
        let menuViewController = TableWithOptionalButtonViewController(viewModel: viewModel)
        menuViewController.title = "Menu"
        let closeable = CloseableViewController(contents: menuViewController, delegate: self)
        return closeable
    }

    var profileScreen: UIViewController {
        guard userService.currentUser != nil,
            let viewModel = UserProfileViewModel(userService: userService, delegate: self) else {
            os_log("not logged in")
            return UIViewController()
        }

        let viewController = TableWithOptionalButtonViewController(viewModel: viewModel)
        viewController.title = "Profile"
        return viewController
    }

    func historyScreen(isInitial: Bool) -> UIViewController {
        guard let user = userService.currentUser else {
            os_log("not logged in")
            return UIViewController()
        }

        let historySection = ParkingHistorySectionDataSource(parkingActionsService: parkingActionsService, user: user)
        let viewModel = TableWithOptionalButtonViewModel(sections: [historySection], actionButtonTitle: nil)
        let viewController = TableWithOptionalButtonViewController(viewModel: viewModel)
        viewController.title = "History"
        if isInitial {
            return CloseableViewController(contents: viewController, delegate: self)
        } else {
            return viewController
        }
    }

    func vehiclesScreen(isInitial: Bool) -> UIViewController {
        guard let viewModel = VehiclesViewModel(userService: userService,
            vehiclesService: vehiclesService, delegate: self) else {
            os_log("Couldn't create a view model")
            return UIViewController()
        }
        let viewController = TableWithOptionalButtonViewController(viewModel: viewModel)
        viewController.title = "Vehicles"
        if isInitial {
            return CloseableViewController(contents: viewController, delegate: self)
        } else {
            return viewController
        }
    }

    func present(_ viewController: UIViewController) {
        if let navigationController = navigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else {
            navigationController = UINavigationController()
            navigationController?.pushViewController(viewController, animated: false)
            presentationContext?.present(navigationController!, animated: true)
        }
    }

    func dismissPresentedViewController() {
        if let navigationController = navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            cleanup(completion: { [weak self] in
                guard let `self` = self else {
                    os_log("memory leak")
                    return
                }
                delegate?.flowCoordinatorDidComplete(self)
            })
        }
    }
}
