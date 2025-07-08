//
//  DefaultPermissionUseCase.swift
//  Walkie-iOS
//
//  Created by 고아라 on 7/8/25.
//

struct DefaultPermissionUseCase {
    
    static func make() -> PermissionUseCase {
        AppPermissionUseCase(
            locationUC: DefaultLocationPermissionUseCase(),
            motionUC: DefaultMotionPermissionUseCase(),
            notificationUC: DefaultNotificationPermissionUseCase()
        )
    }
}
