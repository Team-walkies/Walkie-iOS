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
import BackgroundTasks
import Observation

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
    var loginInfo: LoginUserInfo = LoginUserInfo()
    
    var stepCoordinator: StepCoordinator?
    private var cancellables: Set<AnyCancellable> = []
    
    init(diContainer: DIContainer) {
        self.diContainer = diContainer
        initializeStepCoordinator()
        NotificationCenter.default
            .publisher(for: .reissueFailed)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.changeToSplash()
            }
            .store(in: &cancellables)
    }
    
    private func initializeStepCoordinator() {
        self.stepCoordinator = StepCoordinator(diContainer: diContainer, appCoordinator: self)
    }
    
    @ViewBuilder
    func buildScene(_ scene: AppScene) -> some View {
        switch scene {
        case .splash:
            diContainer.buildSplashView(appCoordinator: self)
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
        case .map:
            diContainer.buildMapView()
        case .tabBar:
            diContainer.buildTabBarView()
        case .complete:
            diContainer.buildSignupView()
        case .egg:
            diContainer.buildEggView(appCoordinator: self)
        case .character:
            diContainer.buildCharacterView()
        case .review:
            diContainer.buildReviewView()
        case let .setting(item, viewModel):
            buildSetting(item, viewModel: viewModel)
        case .service(let item):
            buildService(item)
        case .feedback:
            buildFeedback()
        case .withdraw:
            diContainer.buildWithdrawView()
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
        case .alert(
            let title,
            let content,
            let style,
            let button,
            let cancelAction,
            let checkAction,
            let checkTitle,
            let cancelTitle,
            let tapDismiss
        ):
            ZStack {
                Color.black.opacity(appFullScreenCover != nil ? 0.6 : 0.0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            if tapDismiss {
                                self.dismissFullScreenCover()
                            }
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
                        if tapDismiss {
                            self.dismissFullScreenCover()
                        }
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
    
    @ViewBuilder
    private func buildSetting(_ item: MypageSettingSectionItem, viewModel: MypageMainViewModel) -> some View {
        switch item {
        case .myInfo:
            MypageMyInformationView(viewModel: viewModel)
                .toolbar(.hidden, for: .tabBar)
        case .pushNotification:
            MypagePushNotificationView(viewModel: viewModel)
                .toolbar(.hidden, for: .tabBar)
        }
    }
    
    @ViewBuilder
    private func buildService(_ item: MypageServiceSectionItem) -> some View {
        switch item {
        case .notice:
            MypageWebView(url: MypageNotionWebViewURL.notice.url)
                .toolbar(.hidden, for: .tabBar)
        case .privacyPolicy:
            MypageWebView(url: MypageNotionWebViewURL.privacy.url)
                .toolbar(.hidden, for: .tabBar)
        case .servicePolicy:
            MypageWebView(url: MypageNotionWebViewURL.service.url)
                .toolbar(.hidden, for: .tabBar)
        case .appVersion:
            Text("앱 버전 \(Bundle.main.formattedAppVersion)")
                .toolbar(.hidden, for: .tabBar)
        }
    }
    
    @ViewBuilder
    private func buildFeedback() -> some View {
        MypageWebView(url: MypageNotionWebViewURL.questions.url)
            .toolbar(.hidden, for: .tabBar)
    }
    
    private func updateCurrentScene() {
        if UserManager.shared.hasUserToken { // 기존 사용자
            currentScene = .tabBar
        } else {
            currentScene = .login
        }
    }
    
    func startSplash() {
        currentScene = .splash
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.updateCurrentScene()
        }
    }
    
    func changeToSplash() {
        UserManager.shared.withdraw()
        startSplash()
    }
    
    func buildAlert(
        title: String,
        content: String,
        style: ModalStyleType,
        button: ModalButtonType,
        cancelButtonAction: @escaping () -> Void,
        checkButtonAction: @escaping () -> Void,
        checkButtonTitle: String = "확인",
        cancelButtonTitle: String = "취소",
        tapDismiss: Bool = true
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
                cancelTitle: cancelButtonTitle,
                tapDismiss: tapDismiss
            ),
            onDismiss: nil
        )
    }
    
    private func startStepUpdates() {
        stepCoordinator?.startStepUpdates()
    }
    
    private func stopStepUpdates() {
        stepCoordinator?.stopStepUpdates()
    }
    
    func handleStepRefresh(task: BGAppRefreshTask) {
        stepCoordinator?.handleStepRefresh(task: task)
    }
    
    func executeForegroundActions() {
        // 포그라운드 실시간 걸음 수 추적 시작
        self.startStepUpdates()
        // 백그라운드 스케줄링 모두 취소
        BGTaskManager.shared.cancelAll()
    }
    
    func executeBackgroundActions() {
        // 포그라운드 실시간 걸음 수 추적 종료
        self.stopStepUpdates()
        // 백그라운드 작업 스케줄링
        BGTaskManager.shared.scheduleAppRefresh(.step)
    }
}
