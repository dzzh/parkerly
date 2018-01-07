//
// Created by Zmicier Zaleznicenka on 8/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import os.log
import ParkerlyCore

protocol SelectVehicleViewModelDelegate: class {

    func didSelectVehicle(_ vehicle: Vehicle)
}

class SelectVehicleViewModel: TableWithOptionalButtonViewModel {

    private let vehiclesDataSource: VehiclesSectionDataSource
    private weak var delegate: SelectVehicleViewModelDelegate?

    init(vehiclesService: VehiclesServiceType, user: User, delegate: SelectVehicleViewModelDelegate) {
        vehiclesDataSource = VehiclesSectionDataSource(vehiclesService: vehiclesService, user: user)
        self.delegate = delegate
        super.init(sections: [vehiclesDataSource], actionButtonTitle: nil)
    }

    override func didSelectRow(at indexPath: IndexPath) {
        guard let vehicle = vehiclesDataSource.object(for: indexPath.row) as? Vehicle else {
            os_log("no vehicle at row %d", indexPath.row)
            return
        }
        delegate?.didSelectVehicle(vehicle)
    }
}
