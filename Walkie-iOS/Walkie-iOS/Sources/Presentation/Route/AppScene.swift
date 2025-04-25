//
//  AppScene.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import Foundation

enum AppScene: AppRoute {
    
    case splash
    case nickname
    case complete
    case login
    
    case hatchEgg
    
    case tabBar
    
    var id: String {
        switch self {
        case .splash:
            return "splash"
        case .hatchEgg:
            return "hatchEgg"
        case .nickname:
            return "nickname"
        case .complete:
            return "complete"
        case .login:
            return "login"
        case .tabBar:
            return "tabBar"
        }
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

enum AppSheet: AppRoute {
    case none
    
    var id: String {
        switch self {
        case .none:
            return "none"
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

enum AppFullScreenCover: AppRoute {
    case none
    
    var id: String {
        switch self {
        case .none:
            return "none"
        }
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}
