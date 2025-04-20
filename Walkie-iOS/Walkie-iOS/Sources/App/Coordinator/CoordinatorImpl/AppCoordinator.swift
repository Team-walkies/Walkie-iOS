//
//  AppCoordinator.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import SwiftUI

@Observable
final class AppCoordinator: Coordinator {
    var diContainer: DIContainer

    var path = NavigationPath()

    var sheet: (any AppRoute)?
    var appSheet: AppSheet? {
        get { sheet as? AppSheet }
        set { sheet = newValue }
    }
    var fullScreenCover: (any AppRoute)?
    var appFullScreenCover: AppFullScreenCover? {
        get { fullScreenCover as? AppFullScreenCover }
        set { fullScreenCover = newValue }
    }

    var sheetOnDismiss: (() -> Void)?
    var fullScreenCoverOnDismiss: (() -> Void)?
    
    @State var tabBarCoordinator: TabBarCoordinator

    init(diContainer: DIContainer) {
        self.diContainer = diContainer
        self.tabBarCoordinator = TabBarCoordinator(diContainer: diContainer)
    }

    @ViewBuilder
    func buildScene(_ scene: AppScene) -> some View {
        switch scene {
        case .splash:
            SplashView()
        case .hatchEgg:
            //알 부화 뷰
            EmptyView()
        case .nickname:
            NicknameView()
        case .login:
            LoginView()
        case .tabBar:
            TabBarView(coordinator: tabBarCoordinator)
        case .complete:
            OnboardingCompleteView()
        }
    }

    @ViewBuilder
    func buildSheet(_ sheet: AppSheet) -> some View {
    }

    @ViewBuilder
    func buildFullScreenCover(_ fullScreenCover: AppFullScreenCover) -> some View {
    }
    
}
