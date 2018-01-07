//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import MapKit
import os.log
import ParkerlyCore

protocol ParkingViewModelDelegate: class {

    func didStart(_ parkingAction: ParkingAction)

    func didStop(_ parkingAction: ParkingAction)

    func wantsMenu()

    func wantsVehicles()
}

protocol ParkingViewModelSelectionDelegate: class {

    func didSelectParkingZone(_ parkingZone: ParkingZone?)

    func didSelectVehicle(_ vehicle: Vehicle?)
}

protocol ParkingViewModelType {

    var delegate: ParkingViewModelDelegate? { get set }
    var selectionDelegate: ParkingViewModelSelectionDelegate? { get set }

    var parkingAction: ParkingAction? { get }

    var selectedVehicle: Vehicle? { get }

    var selectedZone: ParkingZone? { get }

    func getAnnotations(completion: @escaping (ParkerlyServiceOperation<[ParkingZoneAnnotation]>) -> Void)

    func handleMenuTap()

    func handleParkingAction()

    func handleVehicleTap()

    func didSelect(_ annotation: MKAnnotation)

    func didDeselect(_ annotation: MKAnnotation)

    // MARK: - Tracking location

    var locationAssistantDelegate: StartParkingLocationAssistantDelegate? { get set }

    func startTrackingLocation(completion: (ParkerlyError?) -> Void)

    func stopTrackingLocation()
}

class ParkingViewModel: ParkingViewModelType {

    private let locationAssistant = StartParkingLocationAssistant()
    private let userService: UserServiceType
    private let parkingZonesService: ParkingZonesServiceType
    private let vehiclesService: VehiclesServiceType

    weak var delegate: ParkingViewModelDelegate?
    weak var selectionDelegate: ParkingViewModelSelectionDelegate?

    init(userService: UserServiceType, parkingZonesService: ParkingZonesServiceType,
         vehiclesService: VehiclesServiceType) {
        self.userService = userService
        self.parkingZonesService = parkingZonesService
        self.vehiclesService = vehiclesService

        updateSelectedVehicle()
    }

    var parkingAction: ParkingAction?

    var selectedVehicle: Vehicle? {
        didSet {
            selectionDelegate?.didSelectVehicle(selectedVehicle)
        }
    }

    var selectedZone: ParkingZone? {
        didSet {
            selectionDelegate?.didSelectParkingZone(selectedZone)
        }
    }

    func getAnnotations(completion: @escaping (ParkerlyServiceOperation<[ParkingZoneAnnotation]>) -> Void) {
        parkingZonesService.getZones { operation in
            switch operation {
            case .completed(let parkingZones):
                let annotations = parkingZones.map { ParkingZoneAnnotation(parkingZone: $0) }
                completion(ParkerlyServiceOperation.completed(annotations))
            case .failed(let error):
                completion(ParkerlyServiceOperation.failed(error))
            }
        }
    }

    func handleParkingAction() {

        // Parking action already available, will stop parking
        if let parkingAction = parkingAction {
            delegate?.didStop(parkingAction)
            self.parkingAction = nil

        // No parking action, will start parking
        } else {
            guard let userId = userService.currentUser?.id, let vehicleId = selectedVehicle?.id,
                  let zoneId = selectedZone?.id else {
                os_log("Can't start parking, some data is missing. User: %@, vehicle: %@, zone: %@",
                        String(describing: userService.currentUser), String(describing: selectedVehicle),
                        String(describing: selectedZone))
                return
            }
            let action = ParkingAction(userId: userId, vehicleId: vehicleId, zoneId: zoneId)
            parkingAction = action
            delegate?.didStart(action)
        }
    }

    func handleMenuTap() {
        delegate?.wantsMenu()
    }

    func handleVehicleTap() {
        delegate?.wantsVehicles()
    }

    func didSelect(_ annotation: MKAnnotation) {
        if let parkingZoneAnnotation = annotation as? ParkingZoneAnnotation {
            selectedZone = parkingZoneAnnotation.parkingZone
        }
    }

    func didDeselect(_ annotation: MKAnnotation) {
        if annotation is ParkingZoneAnnotation {
            selectedZone = nil
        }
    }

    // MARK: - Tracking location

    var locationAssistantDelegate: StartParkingLocationAssistantDelegate? {
        get {
            return locationAssistant.delegate
        } set {
            locationAssistant.delegate = newValue
        }
    }

    func startTrackingLocation(completion: (ParkerlyError?) -> Void) {
        locationAssistant.startTrackingLocation(completion: completion)
    }

    func stopTrackingLocation() {
        locationAssistant.stopTrackingLocation()
    }
}

private extension ParkingViewModel {

    func updateSelectedVehicle() {
        guard let currentUser = userService.currentUser else {
            os_log("not logged in")
            return
        }

        vehiclesService.getDefault(for: currentUser) { [weak self] operation in
            switch operation {
            case .completed(let vehicle):
                self?.selectedVehicle = vehicle
            case .failed(let error):
                self?.selectedVehicle = nil
            }
        }
    }
}