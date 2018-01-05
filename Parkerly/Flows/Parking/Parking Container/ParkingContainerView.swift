//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import ParkerlyCore
import UIKit

class ParkingContainerView: UIView {

    // MARK: - UI Elements

    let container = UIView()
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

    // MARK: - Interface

    func update(for parkingAction: ParkingAction?) {
        if parkingAction != nil {
            actionButton.setTitle("Stop parking", for: .normal)
            actionButton.backgroundColor = .red
        } else {
            actionButton.setTitle("Start parking", for: .normal)
            actionButton.backgroundColor = actionButton.tintColor
        }
    }
}

private extension ParkingContainerView {

    func setup() {
        backgroundColor = .white

        update(for: nil)

        add(container)
        add(actionButton)

        container.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true

        actionButton.topAnchor.constraintEqualToSystemSpacingBelow(container.bottomAnchor, multiplier: 2).isActive = true
        actionButton.bottomAnchor.constraintEqualToSystemSpacingAbove(safeAreaLayoutGuide.bottomAnchor, multiplier: 2).isActive = true
        actionButton.leadingAnchor.constraintEqualToSystemSpacingAfter(safeAreaLayoutGuide.leadingAnchor, multiplier: 2).isActive = true
        actionButton.trailingAnchor.constraintEqualToSystemSpacingBefore(safeAreaLayoutGuide.trailingAnchor, multiplier: 2).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
