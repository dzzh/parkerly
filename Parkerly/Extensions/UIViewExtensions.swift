//
// Created by Zmicier Zaleznicenka on 2/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import UIKit

extension UIView {

    class func update(with updates: @escaping () -> Void, animated: Bool, duration: TimeInterval, delay: TimeInterval,
                      options: UIViewAnimationOptions, completion: ((Bool) -> Void)?) {
        if animated {
            UIView.animate(withDuration: duration, delay: delay, options: options, animations: updates, completion: completion)
        } else {
            updates()
            completion?(true)
        }
    }

    func constraintSubview(_ view: UIView, horizontalInset: CGFloat = 0, verticalInset: CGFloat = 0) {
        assert(view.superview != nil, "subview is not attached")
        view.translatesAutoresizingMaskIntoConstraints = false

        addConstraints([
            NSLayoutConstraint(item: view, attribute: .topMargin, relatedBy: .equal, toItem: self, attribute: .topMargin, multiplier: 1, constant: verticalInset),
            NSLayoutConstraint(item: view, attribute: .bottomMargin, relatedBy: .equal, toItem: self, attribute: .bottomMargin, multiplier: 1, constant: -verticalInset),
            NSLayoutConstraint(item: view, attribute: .leadingMargin, relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 1, constant: horizontalInset),
            NSLayoutConstraint(item: view, attribute: .trailingMargin, relatedBy: .equal, toItem: self, attribute: .trailingMargin, multiplier: 1, constant: -horizontalInset)
        ])
    }
}
