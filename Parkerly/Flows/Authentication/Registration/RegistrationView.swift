//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import UIKit

class RegistrationView: UIView {

    // MARK: - UI Elements

    // Occupies all the safe area space except for space needed for the action button
    private let outerLabelsGuide = UILayoutGuide()

    // Centered vertically inside the outer guide.
    private let innerLabelsGuide = UILayoutGuide()

    private let firstNameDescription = UILabel()
    let firstNameValue = UILabel()

    private let lastNameDescription = UILabel()
    let lastNameValue = UILabel()

    private let usernameDescription = UILabel()
    let usernameValue = UILabel()

    let actionButton = FilledButton()

    // MARK: - Initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
}

private extension RegistrationView {

    func setup() {

        // Subviews configuration

        backgroundColor = .white

        firstNameDescription.text = "First name:"
        firstNameDescription.styleAsDescription()
        firstNameValue.styleAsValue()

        lastNameDescription.text = "Last name: "
        lastNameDescription.styleAsDescription()
        lastNameValue.styleAsValue()

        usernameDescription.text = "Username:"
        usernameDescription.styleAsDescription()
        usernameValue.styleAsValue()

        actionButton.setTitle("Register", for: .normal)

        // Subviews layout

        addLayoutGuide(outerLabelsGuide)
        addLayoutGuide(innerLabelsGuide)

        add(firstNameDescription)
        add(firstNameValue)

        add(lastNameDescription)
        add(lastNameValue)

        add(usernameDescription)
        add(usernameValue)

        add(actionButton)

        outerLabelsGuide.topAnchor.constraintEqualToSystemSpacingBelow(safeAreaLayoutGuide.topAnchor, multiplier: 2).isActive = true
        outerLabelsGuide.leadingAnchor.constraintEqualToSystemSpacingAfter(safeAreaLayoutGuide.leadingAnchor, multiplier: 2).isActive = true
        outerLabelsGuide.trailingAnchor.constraintEqualToSystemSpacingBefore(safeAreaLayoutGuide.trailingAnchor, multiplier: 2).isActive = true

        actionButton.topAnchor.constraintEqualToSystemSpacingBelow(outerLabelsGuide.bottomAnchor, multiplier: 2).isActive = true
        actionButton.bottomAnchor.constraintEqualToSystemSpacingAbove(safeAreaLayoutGuide.bottomAnchor, multiplier: 2).isActive = true
        actionButton.leadingAnchor.constraintEqualToSystemSpacingAfter(safeAreaLayoutGuide.leadingAnchor, multiplier: 2).isActive = true
        actionButton.trailingAnchor.constraintEqualToSystemSpacingBefore(safeAreaLayoutGuide.trailingAnchor, multiplier: 2).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        innerLabelsGuide.widthAnchor.constraint(equalTo: outerLabelsGuide.widthAnchor, multiplier: 1).isActive = true
        innerLabelsGuide.centerXAnchor.constraint(equalTo: outerLabelsGuide.centerXAnchor).isActive = true
        innerLabelsGuide.centerYAnchor.constraint(equalTo: outerLabelsGuide.centerYAnchor).isActive = true

        firstNameDescription.topAnchor.constraintEqualToSystemSpacingBelow(innerLabelsGuide.topAnchor, multiplier: 2).isActive = true
        firstNameDescription.leadingAnchor.constraintEqualToSystemSpacingAfter(innerLabelsGuide.leadingAnchor, multiplier: 2).isActive = true
        firstNameDescription.trailingAnchor.constraintEqualToSystemSpacingBefore(innerLabelsGuide.trailingAnchor, multiplier: 2).isActive = true

        firstNameValue.leadingAnchor.constraintEqualToSystemSpacingAfter(innerLabelsGuide.leadingAnchor, multiplier: 2).isActive = true
        firstNameValue.trailingAnchor.constraintEqualToSystemSpacingBefore(innerLabelsGuide.trailingAnchor, multiplier: 2).isActive = true
        firstNameValue.topAnchor.constraint(equalTo: firstNameDescription.bottomAnchor, constant: 4).isActive = true

        lastNameDescription.topAnchor.constraint(equalTo: firstNameValue.bottomAnchor, constant: 16).isActive = true
        lastNameDescription.leadingAnchor.constraintEqualToSystemSpacingAfter(innerLabelsGuide.leadingAnchor, multiplier: 2).isActive = true
        lastNameDescription.trailingAnchor.constraintEqualToSystemSpacingBefore(innerLabelsGuide.trailingAnchor, multiplier: 2).isActive = true

        lastNameValue.leadingAnchor.constraintEqualToSystemSpacingAfter(innerLabelsGuide.leadingAnchor, multiplier: 2).isActive = true
        lastNameValue.trailingAnchor.constraintEqualToSystemSpacingBefore(innerLabelsGuide.trailingAnchor, multiplier: 2).isActive = true
        lastNameValue.topAnchor.constraint(equalTo: lastNameDescription.bottomAnchor, constant: 4).isActive = true

        usernameDescription.topAnchor.constraint(equalTo: lastNameValue.bottomAnchor, constant: 16).isActive = true
        usernameDescription.leadingAnchor.constraintEqualToSystemSpacingAfter(innerLabelsGuide.leadingAnchor, multiplier: 2).isActive = true
        usernameDescription.trailingAnchor.constraintEqualToSystemSpacingBefore(innerLabelsGuide.trailingAnchor, multiplier: 2).isActive = true

        usernameValue.leadingAnchor.constraintEqualToSystemSpacingAfter(innerLabelsGuide.leadingAnchor, multiplier: 2).isActive = true
        usernameValue.trailingAnchor.constraintEqualToSystemSpacingBefore(innerLabelsGuide.trailingAnchor, multiplier: 2).isActive = true
        usernameValue.bottomAnchor.constraintEqualToSystemSpacingAbove(innerLabelsGuide.bottomAnchor, multiplier: 2).isActive = true
        usernameValue.topAnchor.constraint(equalTo: usernameDescription.bottomAnchor, constant: 4).isActive = true
    }
}

private extension UILabel {

    func styleAsDescription() {
        font = UIFont.systemFont(ofSize: 12, weight: .medium)
        textColor = UIColor.init(white: 0, alpha: 0.5)
    }

    func styleAsValue() {
        font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
}
