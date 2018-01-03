//
// Created by Zmicier Zaleznicenka on 2/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import UIKit

/// A view controller that allows to embed another view controller into it.
class ContainerViewController: UIViewController {

    var containerView: UIView {
        return view
    }

    var containedViewController: UIViewController? {
        willSet {
            if let newViewController = newValue {
                replace(viewController: containedViewController, with: newViewController)
            } else {
                if let oldViewController = containedViewController {
                    removeChild(oldViewController)
                }
            }
        }
    }
}

private extension ContainerViewController {
    private func replace(viewController oldViewController: UIViewController?,
                         with newViewController: UIViewController) {
        oldViewController?.dismissPresentedViewController()
        embed(newViewController, replacing: oldViewController, in: containerView)
    }
}
