//
// Created by Zmicier Zaleznicenka on 2/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import os.log
import UIKit

extension UIView {

    func constraintEdges(_ subview: UIView, constraintToSafeAreaLayoutGuide: Bool = false) {
        assert(subview.superview != nil, "subview is not attached")

        let parent: LayoutAnchorsProvider = constraintToSafeAreaLayoutGuide ? safeAreaLayoutGuide : self

        parent.topAnchor.constraint(equalTo: subview.topAnchor).isActive = true
        parent.bottomAnchor.constraint(equalTo: subview.bottomAnchor).isActive = true
        parent.leadingAnchor.constraint(equalTo: subview.leadingAnchor).isActive = true
        parent.trailingAnchor.constraint(equalTo: subview.trailingAnchor).isActive = true
    }

    class func update(with updates: @escaping () -> Void, animated: Bool, duration: TimeInterval, delay: TimeInterval,
                      options: UIViewAnimationOptions, completion: ((Bool) -> Void)?) {
        if animated {
            UIView.animate(withDuration: duration, delay: delay, options: options, animations: updates, completion: completion)
        } else {
            updates()
            completion?(true)
        }
    }

    func add(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
    }
}

extension NSLayoutAttribute {

    // When defining relations between views, it is needed to manage the sign of a constraint value
    // to guarantee that the constrained view will be properly inset from its related view.
    var paddingMultiplier: CGFloat {
        switch self {
        case .left, .leftMargin, .top, .topMargin, .leading, .leadingMargin, .centerX, .centerXWithinMargins,
             .centerY, .centerYWithinMargins, .firstBaseline, .lastBaseline:
            return 1
        case .right, .rightMargin, .bottom, .bottomMargin, .trailing, .trailingMargin, .width, .height:
            return -1
        case .notAnAttribute:
            os_log("Multiplier should only be called for real attributes")
            return 0
        }
    }
}