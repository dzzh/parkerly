//
// Created by Zmicier Zaleznicenka on 7/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import CoreLocation
import Foundation
import ParkerlyCore

protocol StartParkingLocationAssistantDelegate: class {

    func didUpdateLocation(to location: CLLocation)

    func didFail(with error: ParkerlyError)

    func locationAuthorizationStatusDidChange(to status: CLAuthorizationStatus)
}

protocol StartParkingLocationAssistantType {

    func startTrackingLocation(completion: (ParkerlyError?) -> Void)

    func stopTrackingLocation()
}

class StartParkingLocationAssistant: NSObject {

    // MARK: - Constants

    private let distanceFilter: CLLocationDistance = 10

    // MARK: - State

    weak var delegate: StartParkingLocationAssistantDelegate?

    private let locationManager = CLLocationManager()

    // MARK: - Initialization

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = distanceFilter
    }
}

extension StartParkingLocationAssistant: StartParkingLocationAssistantType {

    func startTrackingLocation(completion: (ParkerlyError?) -> Void) {
        checkAuthorizationStatus(completion: completion)
        locationManager.startUpdatingLocation()
    }

    func stopTrackingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension StartParkingLocationAssistant: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        delegate?.didUpdateLocation(to: location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFail(with: error.parkerlyError)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.locationAuthorizationStatusDidChange(to: status)
    }
}

private extension StartParkingLocationAssistant {

    func checkAuthorizationStatus(completion: (ParkerlyError?) -> Void) {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            completion(nil)
        case .denied, .restricted:
            completion(.locationServicesDisabled)
        case .authorizedAlways, .authorizedWhenInUse:
            completion(nil)
        }
    }
}