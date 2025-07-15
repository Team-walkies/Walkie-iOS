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
    
    func requestLocationAndMotion() -> AnyPublisher<(PermissionState, PermissionState), Never> {
        let loc = locationUC.check()
            .flatMap { status in
                status == .notDetermined
                ? self.locationUC.requestIfNeeded()
                : Just(status).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let mot = motionUC.check()
            .flatMap { status in
                status == .notDetermined
                ? self.motionUC.requestIfNeeded()
                : Just(status).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        return loc
            .flatMap { locStatus in
                mot.map { motStatus in (locStatus, motStatus) }
            }
            .eraseToAnyPublisher()
    }
    
    func requestNotification() -> AnyPublisher<PermissionState, Never> {
        notificationUC.check()
            .flatMap { $0 == .notDetermined
                ? self.notificationUC.requestIfNeeded()
                : Just($0).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
