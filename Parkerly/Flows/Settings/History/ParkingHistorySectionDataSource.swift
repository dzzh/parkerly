//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import ParkerlyCore
import os.log

class ParkingHistorySectionDataSource: TableSectionDataSource {

    // MARK: - State

    private var parkingActions = [ParkingAction]()
    private let user: User

    private let parkingActionsService: ParkingActionsServiceType

    // MARK: - Initialization

    init(parkingActionsService: ParkingActionsServiceType, user: User) {
        self.parkingActionsService = parkingActionsService
        self.user = user
    }

    // MARK: - TableSectionDataSource

    override var numberOfRows: Int {
        return parkingActions.count
    }

    override var header: String? {
        return "History"
    }

    override func object(for row: Int) -> Any? {
        return parkingActions[safe: row]
    }

    override func cellData(for row: Int) -> TableCellDataType? {
        return object(for: row) as? TableCellDataType
    }

    override func reload(completion: ((ParkerlyError?) -> Void)? = nil) {
        parkingActionsService.getCompleted(for: user) { operation in
            switch operation {
            case .completed(let parkingActions):
                self.parkingActions = parkingActions
                completion?(nil)
            case .failed(let error):
                completion?(error)
            }
        }
    }
}

extension ParkingAction: TableCellDataType {

    var title: String {
        return startDateString
    }

    var subtitle: String? {
        return "\(zoneId) - \(vehicleId)"
    }
}
