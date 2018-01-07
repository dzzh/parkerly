//
// Created by Zmicier Zaleznicenka on 2/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import os.log
import ParkerlyCore

class AppCoordinator {

    private var childCoordinator: FlowCoordinatorType?

    private let serviceLocator: ServiceLocatorType
    private let userService: UserServiceType

    private let rootViewController: RootViewController

    init(serviceLocator: ServiceLocatorType, rootViewController: RootViewController) {
        self.serviceLocator = serviceLocator
        self.userService = serviceLocator.getUnwrapped()
        self.rootViewController = rootViewController
    }

    func start() {
        subscribeToNotifications()
        if userService.currentUser == nil {
            showAuthentication()
        } else {
            showParking()
        }
    }
}

// MARK: - Private (Notifications)

private extension AppCoordinator {

    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidLogin), name: UserServiceNotification.didLogin.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidLogout), name: UserServiceNotification.didLogout.name, object: nil)
    }

    @objc func onDidLogin(_ notification: Notification) {
        guard let authCoordinator = childCoordinator as? AuthenticationCoordinator else {
            os_log("Unexpected or missing child coordinator")
            return
        }

        authCoordinator.cleanup { [weak self] in
            self?.showParking()
        }
    }

    @objc func onDidLogout(_ notification: Notification) {
        guard let child = childCoordinator else {
            os_log("Unexpected or missing child coordinator")
            return
        }

        child.cleanup { [weak self] in
            self?.showAuthentication()
        }
    }
}

// MARK: - Private (Actions)

private extension AppCoordinator {

    func showAuthentication() {
        let authCoordinator = AuthenticationCoordinator(userService: userService, presentationContext: rootViewController)
        authCoordinator.start()
        childCoordinator = authCoordinator
    }

    func showParking() {
        let parkingActionsService: ParkingActionsServiceType = serviceLocator.getUnwrapped()
        let parkingZonesService: ParkingZonesServiceType = serviceLocator.getUnwrapped()
        let vehiclesService: VehiclesServiceType = serviceLocator.getUnwrapped()
        let parkingCoordinator = ParkingCoordinator(
            userService: userService, parkingActionsService: parkingActionsService,
            parkingZonesService: parkingZonesService, vehiclesService: vehiclesService,
            presentationContext: rootViewController)
        parkingCoordinator.start()
        childCoordinator = parkingCoordinator
    }
}
