//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import ParkerlyCore
import UIKit

class ParkingContainerViewController: ContainerViewController {

    // MARK: - State

    private let viewModel: ParkingViewModelType
    private let castedView: ParkingContainerView

    // MARK: - Initialization

    init(viewModel: ParkingViewModelType) {
        self.viewModel = viewModel
        castedView = ParkingContainerView(frame: CGRect.zero)
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
        castedView.actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }

    override var navigationItem: UINavigationItem {
        let item = super.navigationItem
        let menuImage = UIImage(named: "ic_menu")?.withRenderingMode(.alwaysOriginal)
        item.leftBarButtonItem = UIBarButtonItem(image: menuImage, style: .plain,
                target: self, action: #selector(didTapMenu))
        return item
    }

    // MARK: - Interface

    func update(child: UIViewController, parkingAction: ParkingAction?) {
        containedViewController = child
        castedView.update(for: parkingAction)
    }

    // MARK: - Target-actions

    @objc func didTapActionButton() {
        viewModel.handleParkingAction()
    }

    @objc func didTapMenu() {
        viewModel.handleMenuTap()
    }

    // MARK: - ContainerViewController

    override var containerView: UIView {
        return castedView.container
    }
}
