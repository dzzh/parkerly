//
// Created by Zmicier Zaleznicenka on 7/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import UIKit

class CloseableView: UIView {

    // MARK: - Layout elements

    let containerView = UIView()
    let closeButton = FilledButton()

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

private extension CloseableView {

    func setup() {
        backgroundColor = .white

        // MARK: - Elements configuration

        closeButton.backgroundColor = .red
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.setTitle("Close", for: .normal)

        // MARK: - Elements layout

        add(containerView)
        add(closeButton)

        containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraintEqualToSystemSpacingAbove(closeButton.topAnchor, multiplier: 2).isActive = true

        closeButton.leadingAnchor.constraintEqualToSystemSpacingAfter(safeAreaLayoutGuide.leadingAnchor, multiplier: 2).isActive = true
        closeButton.trailingAnchor.constraintEqualToSystemSpacingBefore(safeAreaLayoutGuide.trailingAnchor, multiplier: 2).isActive = true
        closeButton.bottomAnchor.constraintEqualToSystemSpacingAbove(safeAreaLayoutGuide.bottomAnchor, multiplier: 2).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
