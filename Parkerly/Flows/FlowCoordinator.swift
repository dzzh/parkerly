//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import os.log
import UIKit

// TODO: abstract routing into a separate layer and move it away from coordinators
enum CoordinatorPresentationMode {
    // Coordinator should present its root VC inside a provided ContainerViewController
    case container
    // Coordinator should present its root VC modally
    case modal
    // Coordinator should present its root VC inside a provided UINavigationController
    case navigation
}

protocol FlowCoordinatorDelegate: class {

    func flowCoordinatorDidComplete(_ flowCoordinator: FlowCoordinatorType)
}

protocol FlowCoordinatorType: class {

    var presentationContext: UIViewController? { get }

    func start()

    func cleanup(completion: () -> Void)
}

class FlowCoordinator: FlowCoordinatorType {

    var childCoordinators: [FlowCoordinatorType] = []
    weak var delegate: FlowCoordinatorDelegate?

    private(set) weak var presentationContext: UIViewController?

    init(presentationContext: UIViewController, delegate: FlowCoordinatorDelegate? = nil) {
        self.presentationContext = presentationContext
    }

    func start() {
        os_log("not implemented")
    }

    func cleanup(completion: () -> Void) {
        completion()
    }
}

extension FlowCoordinator: FlowCoordinatorDelegate {

    func flowCoordinatorDidComplete(_ flowCoordinator: FlowCoordinatorType) {
        var childrenToRemove = [FlowCoordinatorType]()
        while let nextChild = childCoordinators.last {
            childrenToRemove.append(nextChild)
            childCoordinators.removeLast()
            if nextChild === flowCoordinator {
                break
            }
        }

        while let child = childrenToRemove.first {
            child.cleanup(completion: {
                childrenToRemove.removeFirst()
            })
        }
    }
}