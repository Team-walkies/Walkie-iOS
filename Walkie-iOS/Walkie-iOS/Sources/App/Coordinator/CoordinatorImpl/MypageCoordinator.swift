//
//  MypageCoordinator.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import SwiftUI

@Observable
final class MypageCoordinator: Coordinator, ObservableObject {
    var diContainer: DIContainer

    var path = NavigationPath()

    var sheet: (any AppRoute)?
    var appSheet: MypageSheet? {
        get { sheet as? MypageSheet }
        set { sheet = newValue }
    }
    var fullScreenCover: (any AppRoute)?
    var appFullScreenCover: MypageFullScreenCover? {
        get { fullScreenCover as? MypageFullScreenCover }
        set { fullScreenCover = newValue }
    }

    var sheetOnDismiss: (() -> Void)?
    var fullScreenCoverOnDismiss: (() -> Void)?

    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }

    @ViewBuilder
    func buildScene(_ scene: MypageScene) -> some View {
        switch scene {
        case .mypage:
            diContainer.buildMypageView()
        }
    }

    @ViewBuilder
    func buildSheet(_ sheet: MypageSheet) -> some View {
        
    }

    @ViewBuilder
    func buildFullScreenCover(_ fullScreenCover: MypageFullScreenCover) -> some View {
        
    }
    
}
