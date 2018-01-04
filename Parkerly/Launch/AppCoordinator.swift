//
// Created by Zmicier Zaleznicenka on 2/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import os.log
import ParkerlyCore

class AppCoordinator {

    private let rootViewController: RootViewController
    private var childCoordinators: [FlowCoordinatorType] = []

    init(rootViewController: RootViewController) {
        self.rootViewController = rootViewController
    }

    func start() {
        showAuthentication()
    }
}

extension AppCoordinator: AuthenticationCoordinatorDelegate {

    func didLogin(with user: User) {
        guard childCoordinators.count > 0, childCoordinators.last is AuthenticationCoordinator else {
            os_log("Inconsistent state of child coordinators")
            return
        }
        childCoordinators.removeLast()
        showParking()
    }
}

extension AppCoordinator: ParkingCoordinatorDelegate {

    func didLogout() {

    }
}

private extension AppCoordinator {

    func showAuthentication() {
        let authCoordinator = AuthenticationCoordinator(presentationContext: rootViewController)
        authCoordinator.delegate = self
        authCoordinator.start()
        childCoordinators.append(authCoordinator)
    }

    func showParking() {

    }
}
