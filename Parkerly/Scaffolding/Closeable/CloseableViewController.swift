//
// Created by Zmicier Zaleznicenka on 7/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import UIKit

protocol CloseableViewControllerDelegate: class {

    func close()
}

class CloseableViewController: ContainerViewController {

    // MARK: - State

    private let contents: UIViewController
    private let castedView = CloseableView()

    private weak var delegate: CloseableViewControllerDelegate?

    // MARK: - Initialization

    init(contents: UIViewController, delegate: CloseableViewControllerDelegate) {
        self.contents = contents
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    // MARK: - ContainerViewController

    override var containerView: UIView {
        return castedView.containerView
    }

    // MARK: - UIViewController lifecycle

    override var title: String? {
        get {
            return contents.title
        } set {
            contents.title = newValue
        }
    }

    override func loadView() {
        view = castedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        containedViewController = contents
        castedView.closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
    }

    // MARK: - Target-actions

    @objc func didTapCloseButton() {
        delegate?.close()
    }
}
