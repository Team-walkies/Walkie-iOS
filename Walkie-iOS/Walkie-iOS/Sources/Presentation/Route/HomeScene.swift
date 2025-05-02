//
//  HomeScene.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import UIKit

enum HomeScene: AppRoute {
    
    // 루트 뷰
    case home
    
    // 홈 뷰 기준
    case egg
    case character
    case review
    
    var id: String {
        switch self {
        case .home:
            "home"
        case .egg:
            "egg"
        case .character:
            "character"
        case .review:
            "review"
        }
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

enum HomeSheet: AppRoute {
    
    case eggDetail
    case authBottomSheet
    case homeAlarmBottomSheet
    
    public var id: String {
        switch self {
        case .eggDetail:
            return "eggDetail"
        case .authBottomSheet:
            return "authBottomSheet"
        case .homeAlarmBottomSheet:
            return "homeAlarmBottomSheet"
        }
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

enum HomeFullScreenCover: AppRoute {
    
    case authLocationPermissionModal
    case authActivityPermissionModal
    case authAccessPermissionModal

    public var id: String {
        switch self {
        case .authLocationPermissionModal:
            return "authLocationPermissionModal"
        case .authActivityPermissionModal:
            return "authActivityPermissionModal"
        case .authAccessPermissionModal:
            return "authAccessPermissionModal"
        }
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}
