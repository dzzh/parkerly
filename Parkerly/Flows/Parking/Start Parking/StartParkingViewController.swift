//
// Created by Zmicier Zaleznicenka on 4/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import CoreLocation
import MapKit
import ParkerlyCore
import UIKit

class StartParkingViewController: UIViewController {

    // MARK: - Constants

    private let parkingZoneAnnotationIdentifier = "parkingZoneAnnotationViewReuseIdentifier"

    // MARK: - State

    private var viewModel: ParkingViewModelType
    private let castedView: StartParkingView
    private var isFirstLocationUpdate = true

    // MARK: - Initialization

    init(viewModel: ParkingViewModelType) {
        self.viewModel = viewModel
        castedView = StartParkingView(frame: CGRect.zero)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    // MARK: - UIViewController lifecycle

    override func loadView() {
        view = castedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Start parking"

        viewModel.selectionDelegate = self

        castedView.mapView.delegate = self
        castedView.mapView.register(MKMarkerAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: parkingZoneAnnotationIdentifier)

        castedView.selectedVehicleValue.addTarget(self, action: #selector(wantsToSelectVehicle), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.startTrackingLocation { error in
            if let error = error {
                presentError(error)
            }
        }
        viewModel.locationAssistantDelegate = self

        viewModel.getAnnotations { [weak self] operation in
            switch operation {
            case .completed(let annotations):
                self?.castedView.mapView.addAnnotations(annotations)
            case .failed(let error):
                self?.presentError(error)
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopTrackingLocation()
    }

    // MARK: - Target-actions

    @objc func wantsToSelectVehicle() {
        viewModel.handleVehicleTap(inContext: self)
    }
}

extension StartParkingViewController: StartParkingLocationAssistantDelegate {

    func didUpdateLocation(to location: CLLocation) {
        castedView.centerMap(at: location.coordinate, resetSpan: isFirstLocationUpdate)
        isFirstLocationUpdate = false
    }

    func didFail(with error: ParkerlyError) {
        presentError(error)
    }

    func locationAuthorizationStatusDidChange(to status: CLAuthorizationStatus) {
        switch status {
            case .denied, .restricted:
                presentError(.locationServicesDisabled)
            default:
                break
        }
    }
}

extension StartParkingViewController: ParkingViewModelSelectionDelegate {

    func didSelectParkingZone(_ parkingZone: ParkingZone?) {
        castedView.update(forZone: viewModel.selectedZone, vehicle: viewModel.selectedVehicle)
    }

    func didSelectVehicle(_ vehicle: Vehicle?) {
        castedView.update(forZone: viewModel.selectedZone, vehicle: viewModel.selectedVehicle)
    }
}

extension StartParkingViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }

        let annotationView: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: parkingZoneAnnotationIdentifier, for: annotation) as? MKMarkerAnnotationView {
            annotationView = dequeuedView
        } else {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: parkingZoneAnnotationIdentifier)
            annotationView.animatesWhenAdded = true
        }
        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            viewModel.didSelect(annotation)
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let annotation = view.annotation {
            viewModel.didDeselect(annotation)
        }
    }
}