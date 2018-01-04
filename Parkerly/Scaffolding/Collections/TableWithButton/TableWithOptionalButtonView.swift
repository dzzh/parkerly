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

        let showButton = actionButtonTitle != nil
        if let title = actionButtonTitle {
            actionButton.setTitle(title, for: .normal)
        }

        add(tableView)
        tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraintEqualToSystemSpacingAfter(safeAreaLayoutGuide.leadingAnchor, multiplier: 2).isActive = true
        tableView.trailingAnchor.constraintEqualToSystemSpacingBefore(safeAreaLayoutGuide.trailingAnchor, multiplier: 2).isActive = true

        if showButton {
            add(actionButton)
            actionButton.topAnchor.constraintEqualToSystemSpacingBelow(tableView.bottomAnchor, multiplier: 2).isActive = true
            actionButton.bottomAnchor.constraintEqualToSystemSpacingAbove(safeAreaLayoutGuide.bottomAnchor, multiplier: 2).isActive = true
            actionButton.leadingAnchor.constraintEqualToSystemSpacingAfter(safeAreaLayoutGuide.leadingAnchor, multiplier: 2).isActive = true
            actionButton.trailingAnchor.constraintEqualToSystemSpacingBefore(safeAreaLayoutGuide.trailingAnchor, multiplier: 2).isActive = true
            actionButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        } else {
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
    }
}
