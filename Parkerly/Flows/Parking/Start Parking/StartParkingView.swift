//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import CoreLocation
import MapKit
import ParkerlyCore
import UIKit

class StartParkingView: UIView {

    // MARK: - Constants

    private let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)

    // MARK: - UI Elements

    let mapView = MKMapView()

    let labelsContainer = UIView()
    let selectedZoneDescription = UILabel()
    let selectedZoneValue = UILabel()
    let selectedVehicleDescription = UILabel()
    let selectedVehicleValue = UIButton()

    // MARK: - Initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    deinit {
        mapView.delegate = nil
    }

    // MARK: - Interface

    func update(forZone zone: ParkingZone?, vehicle: Vehicle?) {
        let showZone = zone != nil
        selectedZoneDescription.isHidden = !showZone
        selectedZoneValue.isHidden = !showZone
        selectedZoneValue.text = zone?.address

        selectedVehicleValue.setTitle(vehicle?.vrn ?? "not selected", for: .normal)
    }

    func centerMap(at coordinate: CLLocationCoordinate2D, resetSpan: Bool) {
        if resetSpan {
            let region = MKCoordinateRegion(center: coordinate, span: defaultSpan)
            mapView.setRegion(region, animated: true)
        } else {
            mapView.setCenter(coordinate, animated: true)
        }
    }
}

private extension StartParkingView {

    func setup() {
        backgroundColor = .white

        // MARK: - Subviews configuration

        mapView.showsUserLocation = true
        selectedZoneDescription.text = "Zone: "
        selectedVehicleDescription.text = "Vehicle: "
        selectedVehicleValue.setTitleColor(tintColor, for: .normal)
        update(forZone: nil, vehicle: nil)

        // MARK: - Subviews layout

        add(mapView)
        add(labelsContainer)
        add(selectedZoneDescription)
        add(selectedZoneValue)
        add(selectedVehicleDescription)
        add(selectedVehicleValue)

        mapView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraintEqualToSystemSpacingAbove(labelsContainer.topAnchor, multiplier: 2).isActive = true

        labelsContainer.leadingAnchor.constraintEqualToSystemSpacingAfter(safeAreaLayoutGuide.leadingAnchor, multiplier: 2).isActive = true
        labelsContainer.trailingAnchor.constraintEqualToSystemSpacingBefore(safeAreaLayoutGuide.trailingAnchor, multiplier: 2).isActive = true
        labelsContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true

        selectedZoneDescription.topAnchor.constraint(equalTo: labelsContainer.topAnchor).isActive = true
        selectedZoneDescription.leadingAnchor.constraint(equalTo: labelsContainer.leadingAnchor).isActive = true
        selectedZoneDescription.trailingAnchor.constraint(equalTo: selectedZoneValue.leadingAnchor).isActive = true
        selectedZoneDescription.bottomAnchor.constraintEqualToSystemSpacingAbove(selectedVehicleDescription.topAnchor, multiplier: 1).isActive = true
        selectedZoneDescription.setContentCompressionResistancePriority(.required, for: .horizontal)
        selectedZoneDescription.setContentHuggingPriority(.required, for: .horizontal)

        selectedZoneValue.firstBaselineAnchor.constraint(equalTo: selectedZoneDescription.firstBaselineAnchor).isActive = true
        selectedZoneValue.trailingAnchor.constraint(equalTo: labelsContainer.trailingAnchor).isActive = true

        selectedVehicleDescription.leadingAnchor.constraint(equalTo: labelsContainer.leadingAnchor).isActive = true
        selectedVehicleDescription.trailingAnchor.constraint(equalTo: selectedVehicleValue.leadingAnchor).isActive = true
        selectedVehicleDescription.bottomAnchor.constraint(equalTo: labelsContainer.bottomAnchor).isActive = true
        selectedVehicleDescription.setContentCompressionResistancePriority(.required, for: .horizontal)
        selectedVehicleDescription.setContentHuggingPriority(.required, for: .horizontal)

        selectedVehicleValue.firstBaselineAnchor.constraint(equalTo: selectedVehicleDescription.firstBaselineAnchor).isActive = true
        selectedVehicleValue.trailingAnchor.constraint(equalTo: labelsContainer.trailingAnchor).isActive = true
    }
}