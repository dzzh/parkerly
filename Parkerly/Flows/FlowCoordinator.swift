//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import UIKit

protocol FlowCoordinatorType {

    var presentationContext: UIViewController? { get }
}

class FlowCoordinator: FlowCoordinatorType {

    private(set) weak var presentationContext: UIViewController?

    init(presentationContext: UIViewController) {
        self.presentationContext = presentationContext
    }
}
