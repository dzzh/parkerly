//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import ParkerlyCore

protocol RegistrationViewModelDelegate: class {

    func didRegisterNewUser()
}

protocol RegistrationViewModelType {

    var newUser: User { get }

    var delegate: RegistrationViewModelDelegate? { get set }

    func registerNewUser()
}

class RegistrationViewModel {

    weak var delegate: RegistrationViewModelDelegate?

    init(delegate: RegistrationViewModelDelegate? = nil) {
        self.delegate = delegate
    }
}

extension RegistrationViewModel: RegistrationViewModelType {

    var newUser: User {
        return User(firstName: "firstRegister", lastName: "lastRegister", username: "userRegister")
    }

    func registerNewUser() {
        delegate?.didRegisterNewUser()
    }
}
