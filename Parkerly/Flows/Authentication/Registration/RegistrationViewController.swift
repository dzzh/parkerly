//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import ParkerlyCore
import UIKit

class RegistrationViewController: UIViewController {

    // MARK: - State

    private let viewModel: RegistrationViewModelType
    private let castedView: RegistrationView

    // MARK: - Initialization

    init(viewModel: RegistrationViewModelType) {
        self.viewModel = viewModel
        castedView = RegistrationView(frame: CGRect.zero)
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

        title = "Registration"

        fillForm(with: viewModel.newUser)

        castedView.actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }

    // TODO: dealing with navigation bar status can be abstracted away for clarity and encapsulation
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController = navigationController {
            navigationController.setNavigationBarHidden(false, animated: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let navigationController = navigationController {
            navigationController.setNavigationBarHidden(true, animated: true)
        }
    }

    // MARK: - Target-actions

    @objc func didTapActionButton() {
        viewModel.registerNewUser { [weak self] error in
            if let error = error {
                self?.presentError(error)
            }
        }
    }
}

private extension RegistrationViewController {

    func fillForm(with user: User) {
        castedView.firstNameValue.text = user.firstName
        castedView.lastNameValue.text = user.lastName
        castedView.usernameValue.text = user.username
    }
}
