//
// Created by Zmicier Zaleznicenka on 7/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import os.log
import ParkerlyCore

protocol VehiclesViewModelDelegate: class {

    func wantsVehicleDetails(_ vehicle: Vehicle)

    func wantsNewVehicle(for user: User)
}

class VehiclesViewModel: TableWithOptionalButtonViewModel {

    // MARK: - State

    private let userService: UserServiceType
    private let vehiclesService: VehiclesServiceType
    private weak var delegate: VehiclesViewModelDelegate?

    private let vehiclesSectionDataSource: VehiclesSectionDataSource

    // MARK: - Initialization

    init?(userService: UserServiceType, vehiclesService: VehiclesServiceType,
          delegate: VehiclesViewModelDelegate? = nil) {
        self.userService = userService
        self.vehiclesService = vehiclesService
        self.delegate = delegate

        guard let currentUser = userService.currentUser else {
            os_log("not logged in")
            return nil
        }

        vehiclesSectionDataSource = VehiclesSectionDataSource(vehiclesService: vehiclesService, user: currentUser)
        super.init(sections: [vehiclesSectionDataSource], actionButtonTitle: "Add new vehicle")
    }

    // MARK: - TableWithOptionalButtonViewModelType

    override func didSelectRow(at indexPath: IndexPath) {
        guard let vehicle = vehiclesSectionDataSource.object(for: indexPath.row) as? Vehicle else {
            os_log("no vehicle at row %d", indexPath.row)
            return
        }
        delegate?.wantsVehicleDetails(vehicle)
    }

    override func didTapActionButton(completion: ((ParkerlyError?) -> Void)?) {
        guard let currentUser = userService.currentUser else {
            os_log("not logged in")
            return
        }

        delegate?.wantsNewVehicle(for: currentUser)
    }
}
