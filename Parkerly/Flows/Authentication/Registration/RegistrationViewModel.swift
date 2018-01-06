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

    func registerNewUser(completion: @escaping (ParkerlyError?) -> Void)
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

    // TODO: Editing UI
    var newUser: User {
        return User(id: "newUser", firstName: "newFirstName", lastName: "newLastName", username: "newUsername")
    }

    func registerNewUser(completion: @escaping (ParkerlyError?) -> Void) {
        userService.register(newUser) { [weak self] operation in
            switch operation {
            case .completed(_):
                completion(nil)
                self?.delegate?.didRegisterNewUser()
            case .failed(let error):
                completion(error)
            }
        }
    }
}
