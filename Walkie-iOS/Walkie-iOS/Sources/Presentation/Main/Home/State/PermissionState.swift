//
//  PermissionState.swift
//  Walkie-iOS
//
//  Created by ahra on 4/16/25.
//

enum PermissionState {
    case notDetermined
    case denied
    case authorized
}

extension PermissionState {
    var isAuthorized: Bool {
        self == .authorized
    }
}
