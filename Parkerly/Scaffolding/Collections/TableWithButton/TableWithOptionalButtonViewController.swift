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
        castedView.tableView.allowsSelection = viewModel.isTableSelectable

        castedView.actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.reload { [weak self] error in
            if let error = error {
                self?.presentError(error)
            } else {
                self?.castedView.tableView.reloadData()
            }
        }
    }

    // MARK: - Target-actions

    @objc func didTapActionButton() {
        viewModel.didTapActionButton { [weak self] error in
            if let error = error {
                self?.presentError(error)
            }
        }
    }

    // MARK: - Interface

    func reload() {
        viewModel.reload { [weak self] _ in
            self?.castedView.tableView.reloadData()
        }
    }
}

extension TableWithOptionalButtonViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
