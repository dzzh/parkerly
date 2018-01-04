//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import ParkerlyCore
import os.log

// TODO implement
class ParkingHistorySectionDataSource: TableSectionDataSource {

    // MARK: - State

    private let parkingAction: ParkingAction
    private let user: User

    // MARK: - Initialization

    init(parkingAction: ParkingAction, user: User) {
        self.parkingAction = parkingAction
        self.user = user
    }

    // MARK: - TableSectionDataSource

    private(set) var numberOfRows: Int = 4

    var header: String? = "Parking action"

    func cellData(for row: Int) -> TableCellDataType? {
        switch row {
        case 0: return SimpleCellDataType(title: user.username, subtitle: "Username")
        case 1: return SimpleCellDataType(title: parkingAction.zoneId, subtitle: "Zone id")
        case 2: return SimpleCellDataType(title: parkingAction.vehicleId, subtitle: "Vehicle id")
        case 3: return SimpleCellDataType(title: parkingAction.startDateString, subtitle: "Start time")
        default:
            os_log("Unexpected row %d", row)
            return nil
        }
    }

}
