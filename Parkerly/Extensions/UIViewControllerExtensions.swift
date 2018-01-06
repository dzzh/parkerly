//
// Created by Zmicier Zaleznicenka on 2/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import ParkerlyCore
import UIKit

extension UIViewController {

    var defaultAnimationDuration: TimeInterval {
        return 0.25
    }

    func embed(_ viewController: UIViewController, replacing oldViewController: UIViewController?,
               in containerView: UIView? = nil, constraintToSafeAreaLayoutGuide: Bool = false,
               animated: Bool = false, completion: (() -> Void)? = nil) {
        if let oldViewController = oldViewController {
            removeChild(oldViewController, animated: animated)
        }
        embed(viewController, in: containerView ?? view,
              constraintToSafeAreaLayoutGuide: constraintToSafeAreaLayoutGuide,
              animated: animated, completion: completion)
    }

    func embed(_ viewController: UIViewController, in containerView: UIView,
               constraintToSafeAreaLayoutGuide: Bool = false, animated: Bool = false,
               completion: (() -> Void)? = nil) {
        addChildViewController(viewController)
        let subview: UIView = viewController.view
        containerView.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        containerView.constraintEdges(subview, constraintToSafeAreaLayoutGuide: constraintToSafeAreaLayoutGuide)
        subview.alpha = 0.0
        UIView.update(with: { () -> Void in
            subview.alpha = 1.0
        }, animated: animated, duration: defaultAnimationDuration, delay: 0.0, options: [], completion: { _ in
            completion?()
        })
        viewController.didMove(toParentViewController: self)
    }

    func removeChild(_ viewController: UIViewController, animated: Bool = false, completion: (() -> Void)? = nil) {
        viewController.willMove(toParentViewController: nil)

        UIView.update(with: { () -> Void in
            viewController.view.alpha = 0.0
        }, animated: animated, duration: defaultAnimationDuration, delay: 0.0, options: []) { _ in
            viewController.view.removeFromSuperview()
            viewController.removeFromParentViewController()
            completion?()
        }
    }

    func dismissPresentedViewController(_ animated: Bool = false, completion: (() -> Void)? = nil) {
        guard let presentedViewController = presentedViewController else {
            completion?()
            return
        }

        presentedViewController.dismiss(animated: animated, completion: completion)
    }

    func presentError(_ error: ParkerlyError) {
        let alert = UIAlertController(title: "Error", message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Agree and proceed", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
