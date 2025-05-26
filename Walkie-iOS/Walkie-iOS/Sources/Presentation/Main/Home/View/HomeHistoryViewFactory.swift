//
//  HomeHistoryViewFactory.swift
//  Walkie-iOS
//
//  Created by ahra on 4/2/25.
//

import SwiftUI

enum HomeHistoryViewFactory: CaseIterable {
    case egg, character, review
    
    var scene: AppScene {
        switch self {
        case .egg: return .egg
        case .character: return .character
        case .review: return .review
        }
    }
}
