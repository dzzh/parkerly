//
// Created by Zmicier Zaleznicenka on 7/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import ParkerlyCore

protocol VehicleDetailsViewModelDelegate: class {

    func didSaveVehicle()
}

class VehicleDetailsViewModel: TableWithOptionalButtonViewModel {

    // MARK: - State

    private let vehicleDetailsSectionDataSource: VehicleDetailsSectionDataSource
    private let vehiclesService: VehiclesServiceType
    private weak var delegate: VehicleDetailsViewModelDelegate?

    // MARK: - Init

    init?(vehiclesService: VehiclesServiceType, vehicle: Vehicle, delegate: VehicleDetailsViewModelDelegate? = nil) {
        self.vehiclesService = vehiclesService
        self.delegate = delegate
        vehicleDetailsSectionDataSource = VehicleDetailsSectionDataSource(vehicle: vehicle)
        super.init(sections: [vehicleDetailsSectionDataSource], actionButtonTitle: "Save")
        isTableSelectable = false
    }

    // MARK: - TableWithOptionalButtonViewModel

    override func didTapActionButton(completion: ((ParkerlyError?) -> Void)? = nil) {
        let internalCompletion: (ParkerlyServiceOperation<Vehicle>) -> Void = { [weak self] operation in
            if case let .failed(error) = operation {
                completion?(error)
            } else {
                completion?(nil)
                self?.delegate?.didSaveVehicle()
            }
        }

        let vehicle = vehicleDetailsSectionDataSource.editedVehicle
        if vehicle.id != nil {
            vehiclesService.edit(vehicle, completion: internalCompletion)
        } else {
            vehiclesService.create(vehicle, completion: internalCompletion)
        }
    }
}
