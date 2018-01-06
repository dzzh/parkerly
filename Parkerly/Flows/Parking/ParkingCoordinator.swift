//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import ParkerlyCore
import os.log
import UIKit

class ParkingCoordinator: FlowCoordinator {

    private let userService: UserServiceType

    private let navigationController = UINavigationController()
    private var viewModel: ParkingViewModelType
    private let parkingContainerViewController: ParkingContainerViewController

    init(userService: UserServiceType, presentationContext: UIViewController) {
        self.userService = userService
        viewModel = ParkingViewModel(userService: userService)
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
}

extension ParkingCoordinator: ParkingViewModelDelegate {

    func didStart(_ parkingAction: ParkingAction) {
        showParkingAction(parkingAction)
    }

    func didStop(_ parkingAction: ParkingAction) {
        showStartParking()
    }

    func wantsMenu() {
        let settingsCoordinator = SettingsCoordinator(userService: userService, initialScreen: .menu,
                presentationMode: .modal, presentationContext: parkingContainerViewController, delegate: self)
        settingsCoordinator.delegate = self
        childCoordinators.append(settingsCoordinator)
        settingsCoordinator.start()
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