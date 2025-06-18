//
//  AppScene.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import Foundation
import SwiftUI

enum AppScene: AppRoute {
    
    case splash, nickname, complete, login, tabBar
    case map
    case egg, character, review
    case feedback, withdraw
    case setting(item: MypageSettingSectionItem, viewModel: MypageMainViewModel)
    case service(item: MypageServiceSectionItem)
    
    var id: String {
        switch self {
        case .setting(let item, _):
            return "setting_\(item)"
        case .service(let item):
            return "service_\(item)"
        default:
            return String(describing: self)
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
    
    case homeAlarm(height: CGFloat, content: AnyView)
    
    public var id: String {
        switch self {
        case .homeAlarm:
            return "homeAlarm"
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
    var height: CGFloat {
        switch self {
        case .homeAlarm(let height, _):
            return height
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .homeAlarm(_, let view):
            view
        }
    }
}

enum AppFullScreenCover: AppRoute, Identifiable, Hashable {
    case hatchEgg
    case alert(
        title: String,
        content: String,
        style: ModalStyleType,
        button: ModalButtonType,
        cancelAction: () -> Void,
        checkAction: () -> Void,
        checkTitle: String,
        cancelTitle: String
    )
    
    var id: String {
        switch self {
        case .hatchEgg:
            return "hatchEgg"
        case .alert(let title, _, _, _, _, _, _, _):
            return "alert_\(title)"
        }
    }
    
    static func == (lhs: AppFullScreenCover, rhs: AppFullScreenCover) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
