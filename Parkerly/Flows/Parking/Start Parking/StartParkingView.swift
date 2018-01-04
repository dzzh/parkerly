//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import ParkerlyCore
import UIKit

class StartParkingView: UIView {

    // MARK: - UI Elements

    let mapContainer = UIView()

    let informationGuide = UILayoutGuide()
    let selectedZoneDescription = UILabel()
    let selectedZoneValue = UILabel()
    let selectedVehicleDescription = UILabel()
    let selectedVehicleValue = UIButton() // todo handler

    // MARK: - Initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    // MARK: - Interface

    func update(forZone zone: ParkingZone?, vehicle: Vehicle?) {
        let showZone = zone != nil
        selectedZoneDescription.isHidden = !showZone
        selectedZoneValue.isHidden = !showZone
        selectedZoneValue.text = zone?.address

        selectedVehicleValue.setTitle(vehicle?.vrn ?? "not selected", for: .normal)
    }
}

private extension StartParkingView {

    func setup() {
        backgroundColor = .white

        // MARK: - Subviews configuration

        mapContainer.backgroundColor = .yellow
        selectedZoneDescription.text = "Selected zone: "
        selectedVehicleDescription.text = "Vehicle: "
        update(forZone: nil, vehicle: nil)

        // MARK: - Subviews layout

        add(mapContainer)
        addLayoutGuide(informationGuide)
        add(selectedZoneDescription)
        add(selectedZoneValue)
        add(selectedVehicleDescription)
        add(selectedVehicleValue)

        mapContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        mapContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        mapContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        mapContainer.bottomAnchor.constraintEqualToSystemSpacingAbove(informationGuide.topAnchor, multiplier: 2).isActive = true

        informationGuide.leadingAnchor.constraintEqualToSystemSpacingAfter(safeAreaLayoutGuide.leadingAnchor, multiplier: 2).isActive = true
        informationGuide.trailingAnchor.constraintEqualToSystemSpacingBefore(safeAreaLayoutGuide.trailingAnchor, multiplier: 2).isActive = true
        informationGuide.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true

        selectedZoneDescription.topAnchor.constraint(equalTo: informationGuide.topAnchor).isActive = true
        selectedZoneDescription.leadingAnchor.constraint(equalTo: informationGuide.leadingAnchor).isActive = true
        selectedZoneDescription.trailingAnchor.constraint(equalTo: selectedZoneValue.leadingAnchor).isActive = true
        selectedZoneDescription.bottomAnchor.constraintEqualToSystemSpacingAbove(selectedVehicleDescription.topAnchor, multiplier: 1).isActive = true
        selectedZoneDescription.setContentCompressionResistancePriority(.required, for: .horizontal)
        selectedZoneDescription.setContentHuggingPriority(.required, for: .horizontal)

        selectedZoneValue.firstBaselineAnchor.constraint(equalTo: selectedZoneDescription.firstBaselineAnchor).isActive = true
        selectedZoneValue.trailingAnchor.constraint(equalTo: informationGuide.trailingAnchor).isActive = true

        selectedVehicleDescription.leadingAnchor.constraint(equalTo: informationGuide.leadingAnchor).isActive = true
        selectedVehicleDescription.trailingAnchor.constraint(equalTo: selectedVehicleValue.leadingAnchor).isActive = true
        selectedVehicleDescription.bottomAnchor.constraint(equalTo: informationGuide.bottomAnchor).isActive = true
        selectedVehicleDescription.setContentCompressionResistancePriority(.required, for: .horizontal)
        selectedVehicleDescription.setContentHuggingPriority(.required, for: .horizontal)

        selectedVehicleValue.firstBaselineAnchor.constraint(equalTo: selectedVehicleDescription.firstBaselineAnchor).isActive = true
        selectedVehicleValue.trailingAnchor.constraint(equalTo: informationGuide.trailingAnchor).isActive = true
    }
}