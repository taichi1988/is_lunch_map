//
//  MapViewController.swift
//  is_lunch_map
//
//  Created by 行木太一 on 2018/08/07.
//  Copyright © 2018年 yukit.Inc. All rights reserved.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    private lazy var mapView = MKMapView()
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
        initLocationManager()
    }
    
    private func initLayout() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(mapView.snp.width)
        }
    }
    
    private func initLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        mapView.userTrackingMode = .followWithHeading
        mapView.showsUserLocation = true
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied, .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
}
