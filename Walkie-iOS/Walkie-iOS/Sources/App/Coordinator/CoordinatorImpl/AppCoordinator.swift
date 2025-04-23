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
    var currentScene: AppScene = .splash

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
    
    init(diContainer: DIContainer) {
        self.diContainer = diContainer
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.updateCurrentScene()
        }
    }

    @ViewBuilder
    func buildScene(_ scene: AppScene) -> some View {
        switch scene {
        case .splash:
            SplashView()
        case .hatchEgg:
            EmptyView()
        case .nickname:
            NicknameView()
        case .login:
            LoginView()
        case .tabBar:
            TabBarView(
                homeCoordinator: HomeCoordinator(diContainer: diContainer),
                mypageCoordinator: MypageCoordinator(diContainer: diContainer)
            )
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
    
    private func updateCurrentScene() {
        if !UserManager.shared.isUserLogin {
            currentScene = .login
        } else if !UserManager.shared.hasUserNickname {
            currentScene = .nickname
        } else if UserManager.shared.isTapStart {
            currentScene = .tabBar
        } else {
            currentScene = .complete
        }
        
        print("🌀🌀🌀🌀userinfo🌀🌀🌀🌀")
        do {
            let token = try TokenKeychainManager.shared.getAccessToken()
            print(token ?? "no token")
        } catch {
            print("issue;;")
        }
        print("isUserLogin: \(UserManager.shared.isUserLogin)")
        print("nickname: \(UserManager.shared.userNickname ?? "no nickname")")
        print("tapstart: \(UserManager.shared.tapStart ?? false)")
    }
    
}
