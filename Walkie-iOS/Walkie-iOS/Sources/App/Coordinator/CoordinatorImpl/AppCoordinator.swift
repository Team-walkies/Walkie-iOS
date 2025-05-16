//
//  AppCoordinator.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import SwiftUI
import KakaoSDKAuth
import Foundation
import Combine

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
    
    var sheetOnDismiss: (() -> Void)?
    var fullScreenCoverOnDismiss: (() -> Void)?
    
    let tabBarView: AnyView
    
    var loginInfo: LoginUserInfo = LoginUserInfo()
    private var cancellables: Set<AnyCancellable> = []
    
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
        
        // StepManager의 부화 이벤트 구독
        StepManager.shared.hatchEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.presentFullScreenCover(AppFullScreenCover.hatchEgg, onDismiss: nil)
            }
            .store(in: &cancellables)
        
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
            tabBarView
        case .complete:
            diContainer.buildSignupView()
        }
    }
    
    @ViewBuilder
    func buildSheet(_ sheet: AppSheet) -> some View {
    }
    
    @ViewBuilder
    func buildFullScreenCover(_ fullScreenCover: AppFullScreenCover) -> some View {
        switch fullScreenCover {
        case .hatchEgg:
            diContainer.buildHatchEggView()
        case .alert(let title, let content, let style, let button, let cancelAction, let checkAction, let checkTitle, let cancelTitle):
            ZStack {
                Color.black.opacity(appFullScreenCover != nil ? 0.6 : 0.0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            self.dismissFullScreenCover()
                        }
                    }
                Modal(
                    title: title,
                    content: content,
                    style: style,
                    button: button,
                    cancelButtonAction: {
                        self.dismissFullScreenCover()
                        cancelAction()
                    },
                    checkButtonAction: {
                        self.dismissFullScreenCover()
                        checkAction()
                    },
                    checkButtonTitle: checkTitle,
                    cancelButtonTitle: cancelTitle
                )
                .padding(.horizontal, 40)
                .opacity(appFullScreenCover != nil ? 1.0 : 0.0)
            }
            .animation(.easeInOut(duration: 0.25), value: appFullScreenCover != nil)
        }
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
    
    func buildAlert(
        title: String,
        content: String,
        style: ModalStyleType,
        button: ModalButtonType,
        cancelButtonAction: @escaping () -> Void,
        checkButtonAction: @escaping () -> Void,
        checkButtonTitle: String = "확인",
        cancelButtonTitle: String = "취소"
    ) {
        presentFullScreenCover(
            AppFullScreenCover.alert(
                title: title,
                content: content,
                style: style,
                button: button,
                cancelAction: cancelButtonAction,
                checkAction: checkButtonAction,
                checkTitle: checkButtonTitle,
                cancelTitle: cancelButtonTitle
            ),
            onDismiss: nil
        )
    }
}
