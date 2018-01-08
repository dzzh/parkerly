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

    private let vehiclesService: VehiclesServiceType
    private let vehiclesDataSource: VehiclesSectionDataSource
    private let user: User
    private weak var delegate: SelectVehicleViewModelDelegate?

    init(vehiclesService: VehiclesServiceType, user: User, delegate: SelectVehicleViewModelDelegate) {
        self.vehiclesService = vehiclesService
        self.vehiclesDataSource = VehiclesSectionDataSource(vehiclesService: vehiclesService, user: user)
        self.user = user
        self.delegate = delegate
        super.init(sections: [vehiclesDataSource], actionButtonTitle: nil)
    }

    override func didSelectRow(at indexPath: IndexPath) {
        guard let newDefaultVehicle = vehiclesDataSource.object(for: indexPath.row) as? Vehicle else {
            os_log("no vehicle at row %d", indexPath.row)
            return
        }

        func saveAsNotDefault(_ vehicle: Vehicle, then next: @escaping () -> Void) {
            vehiclesService.edit(vehicle.copy(withDefault: false)) { operation in
                switch operation {
                case .completed(_):
                    next()
                case .failed(_):
                    return
                }
            }
        }

        func saveAsDefault() {
            vehiclesService.edit(newDefaultVehicle.copy(withDefault: true)) { [weak self] operation in
                switch operation {
                case .completed(let vehicle):
                    self?.delegate?.didSelectVehicle(vehicle)
                case .failed(_):
                    return
                }
            }
        }

        vehiclesService.getDefault(for: user) { operation in
            switch operation {
            case .completed(let oldDefaultVehicle):
                saveAsNotDefault(oldDefaultVehicle, then: { saveAsDefault() })
            case .failed(let error):
                switch error {
                case .noData:
                    saveAsDefault()
                default:
                    return
                }
            }
        }
    }
}
