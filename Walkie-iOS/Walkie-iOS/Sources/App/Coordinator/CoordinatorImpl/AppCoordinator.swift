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
        case .healthcare:
            diContainer.buildHealthcareView(appCoordinator: self)
        case .map:
            diContainer.buildMapView()
        case .tabBar:
            diContainer.buildTabBarView()
        case .complete:
            diContainer.buildSignupView()
        case .egg:
            diContainer.buildEggView(appCoordinator: self)
                .popGestureEnabled(true)
        case .eggGuide:
            EggGuideView()
        case .character:
            diContainer.buildCharacterView()
                .popGestureEnabled(true)
        case .review:
            diContainer.buildReviewView(appCoordinator: self)
                .popGestureEnabled(true)
        case let .setting(item):
            buildSetting(item)
        case .service(let item):
            buildService(item)
        case .feedback:
            buildFeedback()
        case let .withdraw(nickname):
            diContainer.buildWithdrawView(appCoordinator: self, nickname: nickname)
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
            let cancelTitle
        ):
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
        case .eventAlert(
            let title,
            let style,
            let button,
            let cancelButtonAction,
            let checkButtonAction,
            let checkButtonTitle,
            let cancelButtonTitle,
            let dDay
        ):
            ZStack {
                Color.black.opacity(appFullScreenCover != nil ? 0.6 : 0.0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            self.dismissFullScreenCover()
                        }
                    }
                EventModal(
                    title: title,
                    style: style,
                    button: button,
                    cancelButtonAction: {
                        self.dismissFullScreenCover()
                        cancelButtonAction()
                    },
                    checkButtonAction: {
                        self.dismissFullScreenCover()
                        checkButtonAction()
                    },
                    checkButtonTitle: checkButtonTitle,
                    cancelButtonTitle: cancelButtonTitle,
                    dDay: dDay
                )
                .padding(.horizontal, 40)
                .opacity(appFullScreenCover != nil ? 1.0 : 0.0)
            }
            .animation(.easeInOut(duration: 0.25), value: appFullScreenCover != nil)
        }
    }
    
    @ViewBuilder
    private func buildSetting(_ item: MypageSettingSectionItem) -> some View {
        switch item {
        case let .myInfo(isPublic):
            let viewModel = diContainer.makeMypageMyInformationViewModel(
                appCoordinator: self,
                isPublic: isPublic
            )
            MypageMyInformationView(viewModel: viewModel)
                .toolbar(.hidden, for: .tabBar)
        case let .pushNotification(notifyEggHatches):
            let viewModel = MypagePushNotificationViewModel(
                appCoordinator: self,
                notifyEggHatches: notifyEggHatches
            )
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
    
    func buildEventAlert(
        title: String,
        style: ModalStyleType,
        button: ModalButtonType,
        cancelButtonAction: @escaping () -> Void,
        checkButtonAction: @escaping () -> Void,
        checkButtonTitle: String = "보러가기",
        cancelButtonTitle: String = "닫기",
        dDay: Int
    ) {
        presentFullScreenCover(
            AppFullScreenCover.eventAlert(
                title: title,
                style: style,
                button: button,
                cancelAction: cancelButtonAction,
                checkAction: checkButtonAction,
                checkTitle: checkButtonTitle,
                cancelTitle: cancelButtonTitle,
                dDay: dDay
            ),
            onDismiss: nil
        )
    }
    
    func buildBottomSheet<Content: View>(
        height: CGFloat,
        @ViewBuilder content: @escaping () -> Content,
        disableInteractive: Bool = false
    ) {
        guard sheet == nil else { return }
        presentSheet(
            AppSheet.bottomSheet(
                height: height,
                content: AnyView(
                    content()
                        .interactiveDismissDisabled(disableInteractive)
                )
            )
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
        if UserManager.shared.hasUserToken {
            // 포그라운드 실시간 걸음 수 추적 시작
            self.startStepUpdates()
            // 백그라운드 스케줄링 모두 취소
            BGTaskManager.shared.cancelAll()
        }
    }
    
    func executeBackgroundActions() {
        if UserManager.shared.hasUserToken {
            // 포그라운드 실시간 걸음 수 추적 종료
            self.stopStepUpdates()
            // 백그라운드 작업 스케줄링
            BGTaskManager.shared.scheduleAppRefresh(.step)
        }
    }
}
