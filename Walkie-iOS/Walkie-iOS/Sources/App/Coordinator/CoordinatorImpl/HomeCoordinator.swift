//
//  HomeCoordinator.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import SwiftUI

@Observable
final class HomeCoordinator: Coordinator {
    var diContainer: DIContainer

    var path = NavigationPath()

    var sheet: (any AppRoute)?
    var appSheet: HomeSheet? {
        get { sheet as? HomeSheet }
        set { sheet = newValue }
    }
    var fullScreenCover: (any AppRoute)?
    var appFullScreenCover: HomeFullScreenCover? {
        get { fullScreenCover as? HomeFullScreenCover }
        set { fullScreenCover = newValue }
    }

    var sheetOnDismiss: (() -> Void)?
    var fullScreenCoverOnDismiss: (() -> Void)?

    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }

    @ViewBuilder
    func buildScene(_ scene: HomeScene) -> some View {
        switch scene {
        case .home:
            diContainer.buildHomeView()
        case .egg:
            diContainer.buildEggView()
        case .character:
            diContainer.buildCharacterView()
        case .review:
            diContainer.buildReviewView()
        }
    }

    @ViewBuilder
    func buildSheet(_ sheet: HomeSheet) -> some View {
        
    }

    @ViewBuilder
    func buildFullScreenCover(_ fullScreenCover: HomeFullScreenCover) -> some View {
        
    }
    
}
