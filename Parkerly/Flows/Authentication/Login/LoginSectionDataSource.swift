//
// Created by Zmicier Zaleznicenka on 3/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import ParkerlyCore
import os.log

class LoginSectionDataSource: TableSectionDataSource {

    // MARK: - State

    private var users = [User]()

    private let userService: UserServiceType

    // MARK: - Initialization

    init(userService: UserServiceType) {
        self.userService = userService
    }

    // MARK: - TableSectionDataSource

    override var numberOfRows: Int {
        return users.count
    }

    override var header: String? {
        return "Users"
    }

    override func object(for row: Int) -> Any? {
        return users[safe: row]
    }

    override func cellData(for row: Int) -> TableCellDataType? {
        return object(for: row) as? TableCellDataType
    }

    override func reload(completion: ((ParkerlyError?) -> Void)? = nil) {
        userService.get { operation in
            switch operation {
            case .completed(let users):
                self.users = users
                completion?(nil)
            case .failed(let error):
                completion?(error)
            }
         }
    }
}

extension User: TableCellDataType {

    var title: String {
        return username
    }
}