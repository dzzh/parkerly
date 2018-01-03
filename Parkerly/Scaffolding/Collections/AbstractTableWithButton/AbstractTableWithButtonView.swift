//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import UIKit

class AbstractTableWithButtonView: UIView {

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

private extension AbstractTableWithButtonView {

    func setup() {
        backgroundColor = UIColor.white

        if let title = actionButtonTitle {
            actionButton.setTitle(title, for: .normal)
        } else {
            actionButton.isHidden = true
        }

        tableView.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false

        addSubview(tableView)
        addSubview(actionButton)

        let views: [String: Any] = [
            "table": tableView,
            "button": actionButton
        ]

        let tableHorizontal = "H:|-[table]-|"
        let buttonHorizontal = "H:|-[button]-|"
        let vertical = "V:|-[table]-[button](40)-"

        var allConstraints = [NSLayoutConstraint]()
        allConstraints.append(contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: tableHorizontal, metrics: nil, views: views))
        allConstraints.append(contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: buttonHorizontal, metrics: nil, views: views))
        allConstraints.append(contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: vertical, metrics: nil, views: views))
        addConstraints(allConstraints)
    }
}
