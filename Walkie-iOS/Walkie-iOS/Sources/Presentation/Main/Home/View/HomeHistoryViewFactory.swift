//
//  HomeHistoryViewFactory.swift
//  Walkie-iOS
//
//  Created by ahra on 4/2/25.
//

import SwiftUI

enum HomeHistoryViewFactory: CaseIterable {
    case egg, character, review

    @ViewBuilder
    func buildHistoryView() -> some View {
        switch self {
        case .egg:
            DIContainer.shared.buildEggView()
        case .character:
            DIContainer.shared.buildCharacterView()
        case .review:
            DIContainer.shared.buildReviewView()
        }
    }
}
