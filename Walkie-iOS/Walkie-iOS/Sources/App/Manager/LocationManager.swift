//
//  LocationManager.swift
//  Walkie-iOS
//
//  Created by ahra on 4/11/25.
//

import Foundation

import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation?
    
    static let shared = LocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.distanceFilter = 10
        locationManager.activityType = .fitness
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
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let loc = locations.last else { return }
        if loc.horizontalAccuracy <= 50 {
            currentLocation = loc
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("위치 업데이트 실패:", error)
    }
    
    func getCurrentLocation() -> CLLocation? {
        return locationManager.location
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
}
