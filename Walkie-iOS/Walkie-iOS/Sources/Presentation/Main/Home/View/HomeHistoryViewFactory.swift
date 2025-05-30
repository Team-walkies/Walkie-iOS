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
    func buildHistoryView(appCoordinator: AppCoordinator) -> some View {
        switch self {
        case .egg:
            DIContainer.shared.buildEggView(appCoordinator: appCoordinator)
        case .character:
            DIContainer.shared.buildCharacterView()
        case .review:
            DIContainer.shared.buildReviewView()
        }
    }
}
