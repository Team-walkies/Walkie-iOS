//
//  MotionPermissionUseCase.swift
//  Walkie-iOS
//
//  Created by 고아라 on 7/8/25.
//

import Combine
import CoreMotion

protocol MotionPermissionUseCase {
    func check() -> AnyPublisher<PermissionState, Never>
    func requestIfNeeded() -> AnyPublisher<PermissionState, Never>
}

final class DefaultMotionPermissionUseCase: MotionPermissionUseCase {
    private let manager = CMMotionActivityManager()
    
    func check() -> AnyPublisher<PermissionState, Never> {
        Just(convert(CMMotionActivityManager.authorizationStatus()))
            .eraseToAnyPublisher()
    }
    
    func requestIfNeeded() -> AnyPublisher<PermissionState, Never> {
        let status = CMMotionActivityManager.authorizationStatus()
        guard status == .notDetermined else {
            return Just(convert(status)).eraseToAnyPublisher()
        }
        return Future { promise in
            self.manager.startActivityUpdates(to: .main) { _ in
                self.manager.stopActivityUpdates()
                let updated = CMMotionActivityManager.authorizationStatus()
                promise(.success(self.convert(updated)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func convert(
        _ status: CMAuthorizationStatus
    ) -> PermissionState {
        switch status {
        case .notDetermined: return .notDetermined
        case .authorized: return .authorized
        case .denied, .restricted: return .denied
        @unknown default: return .denied
        }
    }
}
