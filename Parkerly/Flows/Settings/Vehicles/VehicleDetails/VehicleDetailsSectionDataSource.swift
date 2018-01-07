//
// Created by Zmicier Zaleznicenka on 7/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import os.log
import ParkerlyCore

class VehicleDetailsSectionDataSource: TableSectionDataSource {

    // MARK: - State

    // TODO: add actual editing, change to var
    let editedVehicle: Vehicle

    // MARK: - Initialization

   init(vehicle: Vehicle) {
        self.editedVehicle = vehicle.copy(withId: vehicle.id)
    }

    // MARK: - TableSectionDataSource

    override var numberOfRows: Int {
        return editedVehicle.isDefault ? 4 : 3
    }

    override func object(for row: Int) -> Any? {
        return nil
    }

    override func cellData(for row: Int) -> TableCellDataType? {
        switch row {
        case 0: return SimpleCellDataType(title: editedVehicle.userId, subtitle: "User")
        case 1: return SimpleCellDataType(title: editedVehicle.title, subtitle: "Title")
        case 2: return SimpleCellDataType(title: editedVehicle.vrn, subtitle: "Licence plate")
        case 3: return SimpleCellDataType(title: "Default vehicle", subtitle: nil)
        default:
            os_log("unexpected row %d", row)
            return nil
        }
    }
}
