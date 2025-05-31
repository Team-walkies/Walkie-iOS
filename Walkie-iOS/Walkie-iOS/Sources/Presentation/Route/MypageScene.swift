//
//  MypageScene.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import UIKit

enum MypageScene: AppRoute {
    
    case mypage
    case setting(item: MypageSettingSectionItem)
    case service(item: MypageServiceSectionItem)
    case feedback
    case withdraw
    
    var id: String {
        switch self {
        case .mypage:
            return "mypage"
        case .setting(let item):
            return "setting_\(item)"
        case .service(let item):
            return "service_\(item)"
        case .feedback:
            return "feedback"
        case .withdraw:
            return "withdraw"
        }
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

enum MypageSheet: AppRoute {
    case mypage
    
    var id: String {
        switch self {
        case .mypage:
            return "mypage"
        }
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

enum MypageFullScreenCover: AppRoute {
    case mypage

    var id: String {
        switch self {
        case .mypage:
            return "mypage"
        }
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}
