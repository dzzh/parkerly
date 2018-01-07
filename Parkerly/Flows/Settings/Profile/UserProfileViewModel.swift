//
// Created by Zmicier Zaleznicenka on 6/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import ParkerlyCore
import os.log

protocol UserProfileViewModelDelegate: class {

    func didSaveUser()
}

class UserProfileViewModel: TableWithOptionalButtonViewModel {

    // MARK: - State

    private let profileSectionDataSource: UserProfileSectionDataSource
    private let userService: UserServiceType
    private weak var delegate: UserProfileViewModelDelegate?

    // MARK: - Init

    init?(userService: UserServiceType, delegate: UserProfileViewModelDelegate? = nil) {
        self.userService = userService
        self.delegate = delegate
        guard let currentUser = userService.currentUser else {
            os_log("not logged in")
            return nil
        }
        profileSectionDataSource = UserProfileSectionDataSource(user: currentUser)
        super.init(sections: [profileSectionDataSource], actionButtonTitle: "Save")
        isTableSelectable = false
    }

    // MARK: - TableWithOptionalButtonViewModel

    override func didTapActionButton(completion: ((ParkerlyError?) -> Void)? = nil) {
        userService.edit(profileSectionDataSource.editedUser) { [weak self] operation in
            if case let .failed(error) = operation {
                completion?(error)
            } else {
                completion?(nil)
                self?.delegate?.didSaveUser()
            }
        }
    }
}
