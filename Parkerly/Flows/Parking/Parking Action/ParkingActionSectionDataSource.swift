//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import ParkerlyCore
import os.log

class ParkingActionSectionDataSource: TableSectionDataSource {

    // MARK: - State

    private let parkingZonesService: ParkingZonesServiceType
    private let vehiclesService: VehiclesServiceType

    private let parkingAction: ParkingAction
    private var parkingZone: ParkingZone?
    private var vehicle: Vehicle?
    private let user: User

    // MARK: - Initialization

    init(parkingZonesService: ParkingZonesServiceType, vehiclesService: VehiclesServiceType,
         parkingAction: ParkingAction, user: User) {
        self.parkingZonesService = parkingZonesService
        self.vehiclesService = vehiclesService
        self.parkingAction = parkingAction
        self.user = user
    }

    // MARK: - TableSectionDataSourceTypeType

    override var numberOfRows: Int {
        return 4
    }

    override func cellData(for row: Int) -> TableCellDataType? {
        switch row {
        case 0: return SimpleCellDataType(title: user.username, subtitle: "Username")
        case 1: return SimpleCellDataType(title: parkingZone?.address ?? parkingAction.zoneId, subtitle: "Zone")
        case 2: return SimpleCellDataType(title: vehicle?.title ?? parkingAction.vehicleId, subtitle: "Vehicle")
        case 3: return SimpleCellDataType(title: parkingAction.startDateString, subtitle: "Start time")
        default:
            os_log("Unexpected row %d", row)
            return nil
        }
    }

    override func reload(completion: ((ParkerlyError?) -> Void)? = nil) {
        guard let userId = user.id else {
            completion?(.malformedRequest)
            return
        }

        let vehicleId = parkingAction.vehicleId
        parkingZonesService.getZones { [weak self] operation in
            switch operation {
            case .completed(let zones):
                self?.parkingZone = zones.first { $0.id == self?.parkingAction.zoneId }
                self?.vehiclesService.getVehicle(vehicleId, userId: userId) { [weak self] operation in
                    switch operation {
                    case .completed(let vehicle):
                        self?.vehicle = vehicle
                        completion?(nil)
                    case .failed(let error):
                        completion?(error)
                    }
                }
            case .failed(let error):
                completion?(error)
            }
        }
    }
}