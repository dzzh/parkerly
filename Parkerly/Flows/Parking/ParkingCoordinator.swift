//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import ParkerlyCore
import os.log
import UIKit

enum ParkingFlowScreen {
    case parkingHistory
    case startParking
    case stopParking
}

class ParkingCoordinator: FlowCoordinator {

    private let userService: UserServiceType
    private let parkingActionsService: ParkingActionsServiceType
    private let vehiclesService: VehiclesServiceType

    private let navigationController = UINavigationController()
    private var viewModel: ParkingViewModelType
    private let parkingContainerViewController: ParkingContainerViewController

    init(userService: UserServiceType, parkingActionsService: ParkingActionsServiceType,
         parkingZonesService: ParkingZonesServiceType, vehiclesService: VehiclesServiceType,
         presentationContext: UIViewController) {
        self.userService = userService
        self.parkingActionsService = parkingActionsService
        self.vehiclesService = vehiclesService
        viewModel = ParkingViewModel(userService: userService, parkingActionsService: parkingActionsService,
            parkingZonesService: parkingZonesService, vehiclesService: vehiclesService)
        parkingContainerViewController = ParkingContainerViewController(viewModel: viewModel)
        super.init(presentationContext: presentationContext)
        viewModel.delegate = self
    }

    override func start() {
        navigationController.navigationBar.barTintColor = .white
        navigationController.pushViewController(parkingContainerViewController, animated: false)
        guard let container = presentationContext as? ContainerViewController else {
            os_log("Parking flow can only be presented in container context")
            presentationContext?.presentError(.internalError(description: nil))
            return
        }

        viewModel.reloadCurrentAction { [weak self] _ in
            if let parkingAction = self?.viewModel.parkingAction {
                self?.showParkingAction(parkingAction)
            } else {
                self?.showStartParking()
            }
            container.containedViewController = self?.navigationController
        }
    }

    override func cleanup(completion: () -> Void) {
        (presentationContext as? ContainerViewController)?.containedViewController = nil
        super.cleanup(completion: completion)
    }
}

extension ParkingCoordinator: ParkingViewModelDelegate {

    func didStart(_ parkingAction: ParkingAction) {
        showParkingAction(parkingAction)
    }

    func didStop(_ parkingAction: ParkingAction) {
        showHistory()
    }

    func didSeeHistory() {
        showStartParking()
    }

    func wantsMenu() {
        let settingsCoordinator = SettingsCoordinator(userService: userService, parkingActionsService: parkingActionsService,
            vehiclesService: vehiclesService, initialScreen: .menu, presentationContext: parkingContainerViewController,
            delegate: self)
        settingsCoordinator.delegate = self
        settingsCoordinator.start()
        childCoordinator = settingsCoordinator
    }

    func wantsToSelectVehicle(inContext context: UIViewController) {
        guard let currentUser = userService.currentUser else {
            context.presentError(.notLoggedIn)
            return
        }

        vehiclesService.getVehicles(for: currentUser) { [weak self] operation in
            switch operation {
                case .completed(let vehicles):
                    if vehicles.isEmpty {
                        self?.showVehiclesAddition()
                    } else {
                        self?.showVehiclesSelection(user: currentUser)
                    }
                case .failed(let error):
                    context.presentError(error)
            }
        }
    }

    private func showVehiclesSelection(user: User) {
        let vehiclesSelectionViewModel = SelectVehicleViewModel(vehiclesService: vehiclesService, user: user, delegate: self)
        let viewController = TableWithOptionalButtonViewController(viewModel: vehiclesSelectionViewModel)
        presentationContext?.present(viewController, animated: true)
    }

    private func showVehiclesAddition() {
        let settingsCoordinator = SettingsCoordinator(userService: userService, parkingActionsService: parkingActionsService,
            vehiclesService: vehiclesService, initialScreen: .vehicles, presentationContext: parkingContainerViewController,
            delegate: self)
        settingsCoordinator.delegate = self
        settingsCoordinator.start()
        childCoordinator = settingsCoordinator
    }
}

extension ParkingCoordinator: SelectVehicleViewModelDelegate {

    func didSelectVehicle(_ vehicle: Vehicle) {
        viewModel.selectedVehicle = vehicle
        presentationContext?.dismiss(animated: true)
    }
}

private extension ParkingCoordinator {

    func showStartParking() {
        let startParkingViewController = StartParkingViewController(viewModel: viewModel)
        parkingContainerViewController.update(child: startParkingViewController, screen: .startParking)
    }

    func showParkingAction(_ parkingAction: ParkingAction) {
        guard let user = userService.currentUser else {
            presentationContext?.presentError(.notLoggedIn)
            return
        }

        let parkingActionData = ParkingActionSectionDataSource(parkingAction: parkingAction, user: user)
        let parkingActionViewModel = TableWithOptionalButtonViewModel(sections: [parkingActionData], actionButtonTitle: nil)
        parkingActionViewModel.isTableSelectable = false
        let parkingActionViewController = TableWithOptionalButtonViewController(viewModel: parkingActionViewModel)
        parkingActionViewController.title = "Parking action"
        parkingContainerViewController.update(child: parkingActionViewController, screen: .stopParking)
    }

    func showHistory() {
        guard let user = userService.currentUser else {
            presentationContext?.presentError(.notLoggedIn)
            return
        }

        let dataSource = ParkingHistorySectionDataSource(parkingActionsService: parkingActionsService, user: user)
        let viewModel = TableWithOptionalButtonViewModel(sections: [dataSource], actionButtonTitle: nil)
        let viewController = TableWithOptionalButtonViewController(viewModel: viewModel)
        viewController.title = "Parking history"
        parkingContainerViewController.update(child: viewController, screen: .parkingHistory)
    }
}