//
//  AppCoordinator.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import SwiftUI
import KakaoSDKAuth

@Observable
final class AppCoordinator: Coordinator, ObservableObject {
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
    
    var showAlertWithDim: HomeAlertStruct?
    
    var sheetOnDismiss: (() -> Void)?
    var fullScreenCoverOnDismiss: (() -> Void)?
    
    let tabBarView: AnyView
    
    init(diContainer: DIContainer) {
        self.diContainer = diContainer
        
        self.tabBarView = AnyView(
            TabBarView(
                homeCoordinator: HomeCoordinator(diContainer: diContainer),
                mypageCoordinator: MypageCoordinator(diContainer: diContainer)
            )
        )
        
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
            diContainer.buildLoginView()
                .onOpenURL { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        DispatchQueue.main.async {
                            _ = AuthController.handleOpenUrl(url: url)
                        }
                    }
                }
        case .tabBar:
            ZStack {
                tabBarView
                
                if let data = showAlertWithDim {
                    ZStack {
                        Color.black.opacity(0.6)
                            .ignoresSafeArea()
                        
                        Modal(
                            title: data.title,
                            content: data.content,
                            style: .primary,
                            button: .twobutton,
                            cancelButtonAction: {
                                self.showAlertWithDim = nil
                            },
                            checkButtonAction: {
                                if let url = URL(string: UIApplication.openSettingsURLString)
                                    , UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url)
                                }
                                self.showAlertWithDim = nil
                            },
                            checkButtonTitle: "허용하기"
                        )
                        .padding(.horizontal, 40)
                    }
                }
            }
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
        if !UserManager.shared.hasTapLogin {
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
        
        print("nickname: \(UserManager.shared.userNickname ?? "no nickname")")
        print("tapstart: \(UserManager.shared.tapStart ?? false)")
    }
    
}
