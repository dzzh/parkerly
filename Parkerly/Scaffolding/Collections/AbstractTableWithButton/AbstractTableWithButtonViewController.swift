//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import UIKit

class AbstractTableWithButtonViewController: UIViewController {

    // MARK: - State

    private let viewModel: AbstractTableWithButtonViewModel
    private let castedView: AbstractTableWithButtonView

    // MARK: - Initialization

    init(viewModel: AbstractTableWithButtonViewModel) {
        self.viewModel = viewModel
        castedView = AbstractTableWithButtonView(frame: CGRect.zero, actionButtonTitle: viewModel.actionButtonTitle)
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
    }
}

extension AbstractTableWithButtonViewController: UITableViewDelegate {

}
