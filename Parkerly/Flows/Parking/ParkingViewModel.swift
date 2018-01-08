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

    func didSeeHistory()

    func wantsMenu()

    func wantsToSelectVehicle(inContext context: UIViewController)
}

protocol ParkingViewModelSelectionDelegate: class {

    func didSelectParkingZone(_ parkingZone: ParkingZone?)

    func didSelectVehicle(_ vehicle: Vehicle?)
}

protocol ParkingViewModelType {

    var delegate: ParkingViewModelDelegate? { get set }

    var selectionDelegate: ParkingViewModelSelectionDelegate? { get set }

    var parkingAction: ParkingAction? { get }

    var selectedVehicle: Vehicle? { get set }

    var selectedZone: ParkingZone? { get }

    func reloadCurrentAction(completion: @escaping (ParkerlyError?) -> Void)

    func getAnnotations(completion: @escaping (ParkerlyServiceOperation<[ParkingZoneAnnotation]>) -> Void)

    func handleMenuTap()

    func handleParkingAction(from screen: ParkingFlowScreen, completion: ((ParkerlyError?) -> Void)?)

    func handleVehicleTap(inContext context: UIViewController)

    func didSelect(_ annotation: MKAnnotation)

    func didDeselect(_ annotation: MKAnnotation)

    func updateSelectedVehicle()

    // MARK: - Tracking location

    var locationAssistantDelegate: StartParkingLocationAssistantDelegate? { get set }

    func startTrackingLocation(completion: (ParkerlyError?) -> Void)

    func stopTrackingLocation()
}

class ParkingViewModel: ParkingViewModelType {

    private let locationAssistant = StartParkingLocationAssistant()
    private let userService: UserServiceType
    private let parkingActionsService: ParkingActionsServiceType
    private let parkingZonesService: ParkingZonesServiceType
    private let vehiclesService: VehiclesServiceType

    weak var delegate: ParkingViewModelDelegate?
    weak var selectionDelegate: ParkingViewModelSelectionDelegate?

    init(userService: UserServiceType, parkingActionsService: ParkingActionsServiceType,
         parkingZonesService: ParkingZonesServiceType, vehiclesService: VehiclesServiceType) {
        self.userService = userService
        self.parkingActionsService = parkingActionsService
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

    func reloadCurrentAction(completion: @escaping (ParkerlyError?) -> Void) {
        guard let currentUser = userService.currentUser else {
            completion(.notLoggedIn)
            return
        }

        parkingActionsService.getActive(for: currentUser) { [weak self] operation in
            switch operation {
            case .completed(let actions):
                if actions.isEmpty {
                   self?.parkingAction = nil
                } else {
                   self?.parkingAction = actions.first!
                }
                completion(nil)
            case .failed(let error):
                completion(error)
            }
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

    func handleParkingAction(from screen: ParkingFlowScreen, completion: ((ParkerlyError?) -> Void)? = nil) {
        switch screen {
        case .parkingHistory:
            closeParkingHistory(completion: completion)
        case .startParking:
            handleStartParking(completion: completion)
        case .stopParking:
            handleStopParking(completion: completion)
        }
    }

    func handleMenuTap() {
        delegate?.wantsMenu()
    }

    func handleVehicleTap(inContext context: UIViewController) {
        delegate?.wantsToSelectVehicle(inContext: context)
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

    func updateSelectedVehicle() {
        guard let currentUser = userService.currentUser else {
            os_log("not logged in")
            return
        }

        vehiclesService.getDefault(for: currentUser) { [weak self] operation in
            switch operation {
            case .completed(let vehicle):
                self?.selectedVehicle = vehicle
            case .failed(_):
                self?.selectedVehicle = nil
            }
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

    private func closeParkingHistory(completion: ((ParkerlyError?) -> Void)?) {
        delegate?.didSeeHistory()
        completion?(nil)
    }

    private func handleStartParking(completion: ((ParkerlyError?) -> Void)?) {
        guard let userId = userService.currentUser?.id else {
            completion?(.notLoggedIn)
            return
        }

        guard let vehicleId = selectedVehicle?.id else {
            completion?(.noVehicleSelected)
            return
        }

        guard let zoneId = selectedZone?.id else {
            completion?(.noParkingZoneSelected)
            return
        }

        let action = ParkingAction(userId: userId, vehicleId: vehicleId, zoneId: zoneId)
        parkingActionsService.start(action) { [weak self] operation in
            switch operation {
            case .completed(let action):
                self?.parkingAction = action
                completion?(nil)
                self?.delegate?.didStart(action)
            case .failed(let error):
                completion?(error)
            }
        }
    }

    private func handleStopParking(completion: ((ParkerlyError?) -> Void)?) {
        guard let parkingAction = parkingAction else {
            completion?(.internalError(description: nil))
            return
        }

        parkingActionsService.stop(parkingAction) { [weak self] operation in
            switch operation {
            case .completed(let action):
                self?.parkingAction = nil
                completion?(nil)
                self?.delegate?.didStop(action)
            case .failed(let error):
                completion?(error)
            }
        }
    }
}