//
//  AppCoordinator.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import SwiftUI
import KakaoSDKAuth

import Foundation

extension Notification.Name {
    static let reissueFailed = Notification.Name("reissueFailed")
}

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
    
    var loginInfo: LoginUserInfo = LoginUserInfo()
    
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
        
        NotificationCenter.default.addObserver(
            forName: .reissueFailed,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.changeRoot()
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
            diContainer.buildNicknameView()
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
            diContainer.buildSignupView()
        }
    }

    @ViewBuilder
    func buildSheet(_ sheet: AppSheet) -> some View {
    }

    @ViewBuilder
    func buildFullScreenCover(_ fullScreenCover: AppFullScreenCover) -> some View {
    }
    
    private func updateCurrentScene() {
        if UserManager.shared.hasUserToken { // 기존 사용자
            currentScene = .tabBar
        } else {
            currentScene = .login
        }
        
        print("🌀🌀🌀🌀\(currentScene)🌀🌀🌀🌀")
        print("🌀🌀🌀🌀userinfo🌀🌀🌀🌀")
        
        do {
            let token = try TokenKeychainManager.shared.getAccessToken()
            let refresh = try TokenKeychainManager.shared.getRefreshToken()
            print("💁💁access💁💁")
            print(token ?? "no token")
            print("💁💁access💁💁")
            print("💁💁refresh💁💁")
            print(refresh ?? "no token")
            print("💁💁refresh💁💁")
        } catch {
            print("no token")
        }
    }
    
    func changeRoot() {
        UserManager.shared.withdraw()
        currentScene = .splash
        updateCurrentScene()
    }
}
