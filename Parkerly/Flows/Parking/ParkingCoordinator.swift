//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import ParkerlyCore
import os.log
import UIKit

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
        viewModel = ParkingViewModel(userService: userService, parkingZonesService: parkingZonesService,
            vehiclesService: vehiclesService)
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

        if let parkingAction = viewModel.parkingAction {
            showParkingAction(parkingAction)
        } else {
            showStartParking()
        }

        container.containedViewController = navigationController
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

    func wantsVehicles() {
        let settingsCoordinator = SettingsCoordinator(userService: userService, parkingActionsService: parkingActionsService,
            vehiclesService: vehiclesService, initialScreen: .vehicles, presentationContext: parkingContainerViewController,
            delegate: self)
        settingsCoordinator.delegate = self
        settingsCoordinator.start()
        childCoordinator = settingsCoordinator
    }
}

private extension ParkingCoordinator {

    func showStartParking() {
        let startParkingViewController = StartParkingViewController(viewModel: viewModel)
        parkingContainerViewController.update(child: startParkingViewController, parkingAction: nil)
    }

    func showParkingAction(_ parkingAction: ParkingAction) {
        guard let user = userService.currentUser else {
            os_log("Not logged in")
            return
        }
        let parkingActionData = ParkingActionSectionDataSource(parkingAction: parkingAction, user: user)
        let parkingActionViewModel = TableWithOptionalButtonViewModel(sections: [parkingActionData], actionButtonTitle: nil)
        parkingActionViewModel.isTableSelectable = false
        let parkingActionViewController = TableWithOptionalButtonViewController(viewModel: parkingActionViewModel)
        parkingActionViewController.title = "Parking action"
        parkingContainerViewController.update(child: parkingActionViewController, parkingAction: parkingAction)
    }
}