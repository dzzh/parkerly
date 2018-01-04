//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import os.log
import UIKit

protocol FlowCoordinatorType {

    var presentationContext: UIViewController? { get }

    func start()

    func cleanup(completion: () -> Void)
}

class FlowCoordinator: FlowCoordinatorType {

    private(set) weak var presentationContext: UIViewController?

    init(presentationContext: UIViewController) {
        self.presentationContext = presentationContext
    }

    func start() {
        os_log("not implemented")
    }

    func cleanup(completion: () -> Void) {
        completion()
    }
}
