//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import ParkerlyCore
import os.log

protocol ParkingViewModelDelegate: class {

    func didStart(_ parkingAction: ParkingAction)

    func didStop(_ parkingAction: ParkingAction)

    func wantsMenu()
}

protocol ParkingViewModelType {

    var delegate: ParkingViewModelDelegate? { get set }

    var parkingAction: ParkingAction? { get }

    var selectedVehicle: Vehicle? { get }

    var selectedZone: ParkingZone? { get }

    func handleMenuTap()

    func handleParkingAction()
}

class ParkingViewModel: ParkingViewModelType {

    private let userService: UserServiceType

    weak var delegate: ParkingViewModelDelegate?

    init(userService: UserServiceType) {
        self.userService = userService
    }

    var parkingAction: ParkingAction?

    var selectedVehicle: Vehicle? { return nil }

    var selectedZone: ParkingZone? { return nil }

    func handleParkingAction() {
        // Parking action already available, will stop parking
        if let parkingAction = parkingAction {
            delegate?.didStop(parkingAction)
            self.parkingAction = nil
        // No parking action, will start parking
        } else {
            // TODO: implement after wiring the network service
//            guard let userId = userService.currentUser?.id, let vehicleId = selectedVehicle?.id, let zoneId = selectedZone?.id else {
//                os_log("Can't start parking, some data is missing. User: %s, vehicle: %s, zone: %s",
//                        String(describing: userService.currentUser), String(describing: selectedVehicle),
//                        String(describing: selectedZone))
//                return
//            }
//            let action = ParkingAction(userId: userId, vehicleId: vehicleId, zoneId: zoneId)
            let action = ParkingAction(userId: "xxx", vehicleId: "yyy", zoneId: "zzz")
            parkingAction = action
            delegate?.didStart(action)
        }
    }

    func handleMenuTap() {
        delegate?.wantsMenu()
    }
}
