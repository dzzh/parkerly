//
// Created by Zmicier Zaleznicenka on 7/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation
import ParkerlyCore

class VehiclesSectionDataSource: TableSectionDataSource {

    // MARK: - State

    private let user: User
    private let vehiclesService: VehiclesServiceType
    private var vehicles = [Vehicle]()

    // MARK: - Initialization

    init(user: User, vehiclesService: VehiclesServiceType) {
        self.user = user
        self.vehiclesService = vehiclesService
    }

    // MARK: - TableSectionDataSource

    override var numberOfRows: Int {
        return vehicles.count
    }

    override var header: String? {
        return "Vehicles"
    }

    override func object(for row: Int) -> Any? {
        return vehicles[safe: row]
    }

    override func cellData(for row: Int) -> TableCellDataType? {
        return object(for: row) as? TableCellDataType
    }

    override func reload(completion: ((ParkerlyError?) -> Void)? = nil) {
        vehiclesService.getVehicles(for: user) { operation in
            switch operation {
            case .completed(let vehicles):
                self.vehicles = vehicles
                completion?(nil)
            case .failed(let error):
                completion?(error)
            }
        }
    }
}

extension Vehicle: TableCellDataType {

    var subtitle: String? {
        return isDefault ? "default" : nil
    }
}
