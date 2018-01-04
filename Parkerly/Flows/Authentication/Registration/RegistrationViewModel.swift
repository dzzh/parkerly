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

    private let userService: UserServiceType

    init(userService: UserServiceType, delegate: RegistrationViewModelDelegate? = nil) {
        self.userService = userService
        self.delegate = delegate
    }
}

extension RegistrationViewModel: RegistrationViewModelType {

    var newUser: User {
        return User(id: "userRegister", firstName: "firstRegister", lastName: "lastRegister", username: "userRegister")
    }

    func registerNewUser() {
        userService.register(newUser, completion: { [weak self] operation in
            switch operation {
            case .completed(_):
                self?.delegate?.didRegisterNewUser()
            case .failed(let error):
                // TODO proper error handling
                break
            }
        })
    }
}
