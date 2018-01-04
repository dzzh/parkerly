//
// Created by Zmicier Zaleznicenka on 2/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import os.log
import ParkerlyCore

class AppCoordinator {

    private var childCoordinators: [FlowCoordinatorType] = []

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
        guard childCoordinators.count > 0, childCoordinators.last is AuthenticationCoordinator else {
            os_log("Inconsistent state of child coordinators")
            return
        }
        childCoordinators.removeLast()
        if childCoordinators.isEmpty {
            showParking()
        }
    }

    @objc func onDidLogout(_ notification: Notification) {
        while !childCoordinators.isEmpty, !(childCoordinators.last is AuthenticationCoordinator) {
            childCoordinators.removeLast()
        }
        childCoordinators.removeLast()
        showAuthentication()
    }
}

// MARK: - Private (Actions)

private extension AppCoordinator {

    func showAuthentication() {
        let authCoordinator = AuthenticationCoordinator(userService: userService, presentationContext: rootViewController)
        authCoordinator.start()
        childCoordinators.append(authCoordinator)
    }

    func showParking() {
        let parkingCoordinator = ParkingCoordinator(userService: userService, presentationContext: rootViewController)
        parkingCoordinator.start()
        childCoordinators.append(parkingCoordinator)
    }
}
