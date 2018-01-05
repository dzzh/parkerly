//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import UIKit

class StartParkingViewController: UIViewController {

    // MARK: - State

    private let viewModel: ParkingViewModelType
    private let castedView: StartParkingView

    // MARK: - Initialization

    init(viewModel: ParkingViewModelType) {
        self.viewModel = viewModel
        castedView = StartParkingView(frame: CGRect.zero)
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
        title = "Start parking"
    }
}
