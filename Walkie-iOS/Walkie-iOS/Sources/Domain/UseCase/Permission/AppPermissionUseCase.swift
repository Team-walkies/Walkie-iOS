//
//  AppPermissionUseCase.swift
//  Walkie-iOS
//
//  Created by 고아라 on 7/8/25.
//

import Combine

final class AppPermissionUseCase: PermissionUseCase {
    
    private let locationUC: LocationPermissionUseCase
    private let motionUC: MotionPermissionUseCase
    private let notificationUC: NotificationPermissionUseCase
    
    init(
        locationUC: LocationPermissionUseCase,
        motionUC: MotionPermissionUseCase,
        notificationUC: NotificationPermissionUseCase
    ) {
        self.locationUC = locationUC
        self.motionUC = motionUC
        self.notificationUC = notificationUC
    }
}

extension AppPermissionUseCase {
    
    func execute() -> AnyPublisher<HomePermissionState, Never> {
        Publishers
            .CombineLatest3(
                locationUC.check(),
                motionUC.check(),
                notificationUC.check()
            )
            .map { loc, motion, alarm in
                HomePermissionState(
                    isLocationChecked: loc,
                    isMotionChecked: motion,
                    isAlarmChecked: alarm
                )
            }
            .eraseToAnyPublisher()
    }
    
    func requestAllIfNeeded() -> AnyPublisher<HomePermissionState, Never> {
        let locRequest = locationUC.check()
            .flatMap { status -> AnyPublisher<PermissionState, Never> in
                status == .notDetermined
                ? self.locationUC.requestIfNeeded()
                : Just(status).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let motionRequest = motionUC.check()
            .flatMap { status -> AnyPublisher<PermissionState, Never> in
                status == .notDetermined
                ? self.motionUC.requestIfNeeded()
                : Just(status).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let notifRequest = notificationUC.check()
            .flatMap { status -> AnyPublisher<PermissionState, Never> in
                status == .notDetermined
                ? self.notificationUC.requestIfNeeded()
                : Just(status).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        return Publishers
            .CombineLatest3(locRequest, motionRequest, notifRequest)
            .map { loc, motion, alarm in
                HomePermissionState(
                    isLocationChecked: loc,
                    isMotionChecked: motion,
                    isAlarmChecked: alarm
                )
            }
            .eraseToAnyPublisher()
    }
}
