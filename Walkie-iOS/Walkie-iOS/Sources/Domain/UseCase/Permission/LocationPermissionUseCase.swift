//
//  LocationPermissionUseCase.swift
//  Walkie-iOS
//
//  Created by 고아라 on 7/8/25.
//

import Combine
import CoreLocation

protocol LocationPermissionUseCase {
    func check() -> AnyPublisher<PermissionState, Never>
    func requestIfNeeded() -> AnyPublisher<PermissionState, Never>
}

final class DefaultLocationPermissionUseCase: NSObject, LocationPermissionUseCase {
    private let manager = CLLocationManager()
    private let subject = PassthroughSubject<PermissionState, Never>()
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func check() -> AnyPublisher<PermissionState, Never> {
        Just(convert(manager.authorizationStatus)).eraseToAnyPublisher()
    }
    
    func requestIfNeeded() -> AnyPublisher<PermissionState, Never> {
        let status = manager.authorizationStatus
        guard status == .notDetermined else {
            return Just(convert(status)).eraseToAnyPublisher()
        }
        manager.requestAlwaysAuthorization()
        return subject
            .first()
            .eraseToAnyPublisher()
    }
    
    private func convert(
        _ status: CLAuthorizationStatus
    ) -> PermissionState {
        switch status {
        case .notDetermined: return .notDetermined
        case .authorizedAlways, .authorizedWhenInUse: return .authorized
        case .denied, .restricted: return .denied
        @unknown default: return .denied
        }
    }
}

extension DefaultLocationPermissionUseCase: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        subject.send(convert(status))
    }
}
