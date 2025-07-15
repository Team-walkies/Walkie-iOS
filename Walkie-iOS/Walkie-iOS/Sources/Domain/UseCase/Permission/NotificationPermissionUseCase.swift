//
//  NotificationPermissionUseCase.swift
//  Walkie-iOS
//
//  Created by 고아라 on 7/8/25.
//

import Combine
import UserNotifications

protocol NotificationPermissionUseCase {
    func check() -> AnyPublisher<PermissionState, Never>
    func requestIfNeeded() -> AnyPublisher<PermissionState, Never>
}

final class DefaultNotificationPermissionUseCase: NotificationPermissionUseCase {
    private let center = UNUserNotificationCenter.current()
    
    func check() -> AnyPublisher<PermissionState, Never> {
        Future { promise in
            self.center.getNotificationSettings { settings in
                let state: PermissionState
                switch settings.authorizationStatus {
                case .notDetermined: state = .notDetermined
                case .denied: state = .denied
                case .authorized, .provisional, .ephemeral: state = .authorized
                @unknown default: state = .denied
                }
                promise(.success(state))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func requestIfNeeded() -> AnyPublisher<PermissionState, Never> {
        Future { promise in
            self.center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                promise(.success(granted ? .authorized : .denied))
            }
        }
        .eraseToAnyPublisher()
    }
}
