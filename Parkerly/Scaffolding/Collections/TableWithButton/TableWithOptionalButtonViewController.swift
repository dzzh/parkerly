//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import UIKit

class TableWithOptionalButtonViewController: UIViewController {

    // MARK: - State

    private let viewModel: TableWithOptionalButtonViewModelType
    private let castedView: TableWithOptionalButtonView

    // MARK: - Initialization

    init(viewModel: TableWithOptionalButtonViewModelType) {
        self.viewModel = viewModel
        castedView = TableWithOptionalButtonView(frame: CGRect.zero, actionButtonTitle: viewModel.actionButtonTitle)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    // MARK: - UIViewController lifecycle

    override func loadView() {
        view = castedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        castedView.tableView.delegate = self
        castedView.tableView.dataSource = viewModel

        castedView.actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }

    // MARK: - Target-actions

    @objc func didTapActionButton() {
        viewModel.handleActionButtonTap()
    }
}

extension TableWithOptionalButtonViewController: UITableViewDelegate {

}
