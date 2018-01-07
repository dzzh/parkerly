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
        super.init()
        isEditable = true
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
        userService.getUsers { operation in
            switch operation {
            case .completed(let users):
                self.users = users
                completion?(nil)
            case .failed(let error):
                completion?(error)
            }
         }
    }

    override func removeObject(for row: Int, completion: @escaping (ParkerlyError?) -> Void) {
        guard let user = users[safe: row] else {
            os_log("No user for row %d", row)
            completion(.internalError(description: nil))
            return
        }

        userService.delete(user) { [weak self] operation in
            switch operation {
            case .completed:
                self?.users.remove(at: row)
                completion(nil)
            case .failed(let error):
                completion(error)
            }
        }
    }
}

extension User: TableCellDataType {

    var title: String {
        return username
    }
}