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
    case egg, eggGuide, character, review
    case feedback, withdraw(nickname: String)
    case setting(item: MypageSettingSectionItem)
    case service(item: MypageServiceSectionItem)
    
    var id: String {
        switch self {
        case .setting(let item):
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
    
    case bottomSheet(height: CGFloat, content: AnyView)
    
    public var id: String {
        switch self {
        case .bottomSheet:
            return "bottomSheet"
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
        case .bottomSheet(let height, _):
            return height
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .bottomSheet(_, let view):
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
    case eventAlert(
        title: String,
        style: ModalStyleType,
        button: ModalButtonType,
        cancelAction: () -> Void,
        checkAction: () -> Void,
        checkTitle: String,
        cancelTitle: String,
        dDay: Int
    )
    
    var id: String {
        switch self {
        case .hatchEgg:
            return "hatchEgg"
        case .alert(let title, _, _, _, _, _, _, _):
            return "alert_\(title)"
        case .eventAlert:
            return "eventAlert"
        }
    }
    
    static func == (lhs: AppFullScreenCover, rhs: AppFullScreenCover) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
