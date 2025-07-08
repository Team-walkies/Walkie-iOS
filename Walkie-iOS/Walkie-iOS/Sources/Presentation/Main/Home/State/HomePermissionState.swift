//
//  HomePermissionstate.swift
//  Walkie-iOS
//
//  Created by 고아라 on 7/8/25.
//

struct HomePermissionState: Equatable {
    let isLocationChecked: PermissionState
    let isMotionChecked: PermissionState
    let isAlarmChecked: PermissionState
    
    static func == (lhs: HomePermissionState, rhs: HomePermissionState) -> Bool {
        return lhs.isLocationChecked == rhs.isLocationChecked &&
        lhs.isMotionChecked == rhs.isMotionChecked &&
        lhs.isAlarmChecked == rhs.isAlarmChecked
    }
}
