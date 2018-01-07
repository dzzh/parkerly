//
// Created by Zmicier Zaleznicenka on 7/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import CoreLocation
import Foundation
import MapKit
import ParkerlyCore

class ParkingZoneAnnotation: NSObject, MKAnnotation {

    let parkingZone: ParkingZone

    init(parkingZone: ParkingZone) {
        self.parkingZone = parkingZone
    }

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: parkingZone.lat, longitude: parkingZone.lon)
    }

    var title: String? {
        return parkingZone.address
    }

    var subtitle: String? {
        return parkingZone.tariff
    }
}
