//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import os.log
import UIKit

protocol FlowCoordinatorDelegate: class {

    /// Notifies the delegate that the coordinator has completed its work and can be safely removed from the stack.
    /// - parameter flowCoordinator: completed coordinator
    func flowCoordinatorDidComplete(_ flowCoordinator: FlowCoordinatorType)
}

protocol FlowCoordinatorType: class {

    var presentationContext: UIViewController? { get }

    /// Receives control over the presentation.
    func start()

    /// Dismisses and deallocates all presented controllers, and performs other cleanup tasks that are necessary.
    /// After this method completes, the coordinator is ready to be removed from the stack.
    /// - parameter completion: completion block
    func cleanup(completion: () -> Void)
}

class FlowCoordinator: FlowCoordinatorType {

    var childCoordinator: FlowCoordinatorType?
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
        childCoordinator = nil
    }
}