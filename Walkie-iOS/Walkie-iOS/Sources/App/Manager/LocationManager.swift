//
//  LocationManager.swift
//  Walkie-iOS
//
//  Created by ahra on 4/11/25.
//

import Foundation

import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private var locationManager: CLLocationManager!
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func requestLocation() {
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("😬😬denied😬😬😬")
        @unknown default:
            break
        }
    }
}
