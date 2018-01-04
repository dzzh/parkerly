//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import UIKit

protocol LayoutAnchorsProvider {

    var leadingAnchor: NSLayoutXAxisAnchor { get }

    var trailingAnchor: NSLayoutXAxisAnchor { get }

    var leftAnchor: NSLayoutXAxisAnchor { get }

    var rightAnchor: NSLayoutXAxisAnchor { get }

    var topAnchor: NSLayoutYAxisAnchor { get }

    var bottomAnchor: NSLayoutYAxisAnchor { get }

    var widthAnchor: NSLayoutDimension { get }

    var heightAnchor: NSLayoutDimension { get }

    var centerXAnchor: NSLayoutXAxisAnchor { get }

    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: LayoutAnchorsProvider {

}

extension UILayoutGuide: LayoutAnchorsProvider {

}

extension NSLayoutYAxisAnchor {

    func constraintEqualToSystemSpacingAbove(_ anchor: NSLayoutYAxisAnchor, multiplier: CGFloat) -> NSLayoutConstraint {
        return anchor.constraintEqualToSystemSpacingBelow(self, multiplier: multiplier)
    }
}

extension NSLayoutXAxisAnchor {

    func constraintEqualToSystemSpacingBefore(_ anchor: NSLayoutXAxisAnchor, multiplier: CGFloat) -> NSLayoutConstraint {
        return anchor.constraintEqualToSystemSpacingAfter(self, multiplier: multiplier)
    }
}
