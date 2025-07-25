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
    var permissionFlow: PermissionFlowCoordinator?
    var eventFlow: EventFlowCoordinator?
    private var cancellables: Set<AnyCancellable> = []
    private var onHatchDismiss: (() -> Void)?
    
    init(
        diContainer: DIContainer
    ) {
        self.diContainer = diContainer
        initializeCoordinator()
        NotificationCenter.default
            .publisher(for: .reissueFailed)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.changeToSplash()
            }
            .store(in: &cancellables)
    }
    
    private func initializeCoordinator() {
        self.stepCoordinator = StepCoordinator(diContainer: diContainer, appCoordinator: self)
        self.permissionFlow = PermissionFlowCoordinator(
            locationUC: diContainer.resolveLocationPermissionUseCase(),
            motionUC: diContainer.resolveMotionPermissionUseCase(),
            notifyUC: diContainer.resolveNotificationPermissionUseCase()
        )
        self.eventFlow = EventFlowCoordinator(
            getEventEggUseCase: diContainer.resolveGetEventEggUseCase()
        )
        bindPermissionFlow()
        bindHatchPublisher()
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

extension AppCoordinator {
    
    func handleHomeEntry() {
        stopStepUpdates()
        permissionFlow?.start()
        eventFlow?.checkEvent()
    }
    
    private func bindPermissionFlow() {
        permissionFlow?.onDenied = { [weak self] step, locOK, motOK, _, _ in
            guard let self = self else { return }
            switch step {
            case .locationMotion:
                let title = step.alertTitle(loc: locOK, mot: motOK)
                let content = step.alertContent(loc: locOK, mot: motOK)
                let height = !locOK && !motOK ? 342 : 266
                
                self.buildBottomSheet(
                    height: CGFloat(height),
                    content: {
                        HomeAuthBSView(
                            showLocation: !locOK,
                            showMotion: !motOK,
                            onConfirm: {
                                self.buildAlert(
                                    title: title,
                                    content: content,
                                    style: .primary,
                                    button: .twobutton,
                                    cancelButtonAction: {
                                        self.permissionFlow?.nextStep()
                                    },
                                    checkButtonAction: {
                                        if let url = URL(string: UIApplication.openSettingsURLString)
                                            , UIApplication.shared.canOpenURL(url) {
                                            UIApplication.shared.open(url)
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            self.permissionFlow?.nextStep()
                                        }
                                    },
                                    checkButtonTitle: "허용하기"
                                )
                            }
                        )
                    },
                    disableInteractive: true
                )
            case .notification:
                self.buildBottomSheet(
                    height: 369,
                    content: {
                        HomeAlarmBSView(
                            onConfirm: {
                                self.permissionFlow?.nextStep()
                            }
                        )
                    },
                    disableInteractive: true
                )
            }
        }
        
        permissionFlow?.onAllAuthorized = {
            print("권한 체크완료")
            DispatchQueue.main.async {
                self.sheet = nil
                self.startStepUpdates()
                self.onHatchDismiss = { [weak self] in
                    self?.showEventEggAlert()
                }
            }
        }
    }
    
    private func bindHatchPublisher() {
        stepCoordinator?
            .hatchPublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] willHatch in
                    guard let self = self else { return }
                    if willHatch {
                        self.presentFullScreenCover(
                            AppFullScreenCover.hatchEgg,
                            onDismiss: self.onHatchDismiss
                        )
                        self.onHatchDismiss = nil
                    } else {
                        showEventEggAlert()
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    private func showEventEggAlert() {
        guard
            let entity = eventFlow?.eventEggEntity,
            entity.canReceive
        else { return }
        
        buildEventAlert(
            title: "알 1개를 선물받았어요!",
            style: .primary,
            button: .twobutton,
            cancelButtonAction: { },
            checkButtonAction: { self.push(AppScene.egg) },
            dDay: entity.dDay
        )
    }
}
