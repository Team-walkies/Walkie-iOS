//
//  TabBarScene.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import UIKit

enum TabBarScene: AppRoute {
    case home
    case mypage
    case map
    
    var id: String {
        switch self {
        case .home:
            return "home"
        case .mypage:
            return "mypage"
        case .map:
            return "map"
        }
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

enum TabBarSheet: AppRoute {
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

enum TabBarFullScreenCover: AppRoute {
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
