//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import UIKit

class TableWithOptionalButtonView: UIView {

    // MARK: - Layout elements

    let tableView = UITableView()
    let actionButton = FilledButton()

    // MARK: - State

    let actionButtonTitle: String?

    // MARK: - Initialization

    required init?(coder aDecoder: NSCoder) {
        actionButtonTitle = nil
        super.init(coder: aDecoder)
        setup()
    }

    init(frame: CGRect, actionButtonTitle: String?) {
        self.actionButtonTitle = actionButtonTitle
        super.init(frame: frame)
        setup()
    }
}

private extension TableWithOptionalButtonView {

    func setup() {
        backgroundColor = UIColor.white

        if let title = actionButtonTitle {
            actionButton.setTitle(title, for: .normal)
        } else {
            actionButton.isHidden = true
        }

        add(tableView)
        add(actionButton)

        tableView.topAnchor.constraintEqualToSystemSpacingBelow(safeAreaLayoutGuide.topAnchor, multiplier: 2).isActive = true
        tableView.leadingAnchor.constraintEqualToSystemSpacingAfter(safeAreaLayoutGuide.leadingAnchor, multiplier: 2).isActive = true
        tableView.trailingAnchor.constraintEqualToSystemSpacingBefore(safeAreaLayoutGuide.trailingAnchor, multiplier: 2).isActive = true

        actionButton.topAnchor.constraintEqualToSystemSpacingBelow(tableView.bottomAnchor, multiplier: 2).isActive = true
        actionButton.bottomAnchor.constraintEqualToSystemSpacingAbove(safeAreaLayoutGuide.bottomAnchor, multiplier: 2).isActive = true
        actionButton.leadingAnchor.constraintEqualToSystemSpacingAfter(safeAreaLayoutGuide.leadingAnchor, multiplier: 2).isActive = true
        actionButton.trailingAnchor.constraintEqualToSystemSpacingBefore(safeAreaLayoutGuide.trailingAnchor, multiplier: 2).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
