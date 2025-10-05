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
    var appFullScreenCover: AppFullScreenCover?
    
    var sheetOnDismiss: (() -> Void)?
    var fullScreenCoverOnDismiss: (() -> Void)?
    var loginInfo: LoginUserInfo = LoginUserInfo()
    
    var stepCoordinator: StepCoordinator?
    var permissionFlow: PermissionFlowCoordinator?
    var eventFlow: EventFlowCoordinator?
    private var cancellables: Set<AnyCancellable> = []
    var selectedTab: TabBarItem = .home
    let permissionsDone = CurrentValueSubject<Bool, Never>(false)
    
    var isModalVisible: Bool = false
    
    let screenHeight = UIScreen.main.bounds.height
    private let remoteConfigManager: RemoteConfigManaging
    
    init(
        diContainer: DIContainer,
        remoteConfigManager: RemoteConfigManaging = RemoteConfigManager.shared
    ) {
        self.diContainer = diContainer
        self.remoteConfigManager = remoteConfigManager
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
        makeScene(scene)
    }
    
    @ViewBuilder
    func buildSheet(_ sheet: AppSheet) -> some View {
        
    }
    @ViewBuilder
    private func fullScreenCoverWrapper<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        ZStack(alignment: .center) {
            Color.black
                .opacity(isModalVisible ? 0.6 : 0.0)
                .ignoresSafeArea()
                .onTapGesture {
                    self.dismissFullScreenCover()
                }
            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .opacity(isModalVisible ? 1.0 : 0.0)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 0.25)) {
                self.isModalVisible = true
            }
        }
    }
    
    func presentFullScreenCover(
        _ fullScreenCover: any AppRoute,
        onDismiss: (() -> Void)? = nil
    ) {
        if let cover = fullScreenCover as? AppFullScreenCover {
            self.appFullScreenCover = cover
            self.fullScreenCoverOnDismiss = onDismiss
        } else {
            self.fullScreenCover = fullScreenCover
            self.fullScreenCoverOnDismiss = onDismiss
        }
    }
    
    @ViewBuilder
    func makeFullScreenCover(_ fullScreenCover: AppFullScreenCover) -> some View {
        switch fullScreenCover {
        case .hatchEgg:
            diContainer.buildHatchEggView()
                .environment(self)
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .opacity(isModalVisible ? 1 : 0)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        self.isModalVisible = true
                    }
                }
        case .alert(
            let title,
            let highlightedContent,
            let highlightedColor,
            let content,
            let style,
            let button,
            let cancelAction,
            let checkAction,
            let checkTitle,
            let cancelTitle
        ):
            fullScreenCoverWrapper {
                Modal(
                    title: title,
                    highlightedContent: highlightedContent,
                    highlightedColor: highlightedColor,
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
            }
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
            fullScreenCoverWrapper {
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
            }
        case let .healthCareGiveEgg(type):
            fullScreenCoverWrapper {
                GiveEggView(viewModel: GiveEggViewModel(coordinator: self, eggType: type))
            }
        }
    }
    
    func dismissFullScreenCover() {
        withAnimation(.easeInOut(duration: 0.25)) {
            self.isModalVisible = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.appFullScreenCover = nil
            self.fullScreenCoverOnDismiss?()
            self.fullScreenCoverOnDismiss = nil
        }
    }
    
    @ViewBuilder
    private func buildSetting(_ item: MypageSettingSectionItem) -> some View {
        switch item {
        case let .myInfo(isPublic, nickname):
            let viewModel = diContainer.makeMypageMyInformationViewModel(
                appCoordinator: self,
                isPublic: isPublic,
                nickname: nickname
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
        highlightedContent: String? = nil,
        highlightedColor: Color? = nil,
        content: String,
        style: ModalStyleType,
        button: ModalButtonType,
        cancelButtonAction: @escaping () -> Void,
        checkButtonAction: @escaping () -> Void,
        checkButtonTitle: String = "확인",
        cancelButtonTitle: String = "취소"
    ) {
        self.appFullScreenCover = AppFullScreenCover.alert(
            title: title,
            highlightedContent: highlightedContent,
            highlightedColor: highlightedColor,
            content: content,
            style: style,
            button: button,
            cancelAction: cancelButtonAction,
            checkAction: checkButtonAction,
            checkTitle: checkButtonTitle,
            cancelTitle: cancelButtonTitle
        )
        self.fullScreenCoverOnDismiss = nil
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
        self.appFullScreenCover = AppFullScreenCover.eventAlert(
            title: title,
            style: style,
            button: button,
            cancelAction: cancelButtonAction,
            checkAction: checkButtonAction,
            checkTitle: checkButtonTitle,
            cancelTitle: cancelButtonTitle,
            dDay: dDay
        )
        self.fullScreenCoverOnDismiss = {
            self.eventFlow?.clearEventEntity()
            self.showHealthcareInfo()
        }
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
    
    func handleStepGoalAchieved(task: BGAppRefreshTask) {
        stepCoordinator?.handleCheckStepGoalOnToday(task: task)
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
    }
    
    private func bindPermissionFlow() {
        permissionFlow?.onRequest = { [weak self] step, locNotDetermined, motNotDetermined in
            guard let self = self else { return }
            switch step {
            case .locationMotion:
                let height = locNotDetermined && motNotDetermined ? 342 : 266
                self.buildBottomSheet(
                    height: CGFloat(height),
                    content: {
                        HomeAuthBSView(
                            showLocation: locNotDetermined,
                            showMotion: motNotDetermined,
                            onConfirm: {
                                self.permissionFlow?.requestPermission(.locationMotion)
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
                            onDenied: {
                                self.permissionFlow?.nextStep()
                            },
                            onConfirm: {
                                self.permissionFlow?.requestPermission(.notification)
                            }
                        )
                    },
                    disableInteractive: true
                )
            }
        }
        
        permissionFlow?.onDenied = { [weak self] step, locOK, motOK in
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
                            onDenied: {
                                self.permissionFlow?.nextStep()
                            },
                            onConfirm: {
                                self.permissionFlow?.nextStep()
                            }
                        )
                    },
                    disableInteractive: true
                )
            }
        }
        
        permissionFlow?.onAllAuthorized = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.sheet = nil
                self.startStepUpdates()
                self.permissionsDone.send(true)
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
                        self.appFullScreenCover = AppFullScreenCover.hatchEgg
                        self.fullScreenCoverOnDismiss = {
                            self.showEventEggAlert()
                        }
                    } else {
                        showEventEggAlert()
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    private func showEventEggAlert() {
        guard
            currentScene == .tabBar,
            selectedTab == .home
        else { return }
        
        eventFlow?.checkEvent { [weak self] in
            guard let self = self else { return }
            
            guard
                let entity = self.eventFlow?.eventEggEntity,
                entity.canReceive
            else {
                self.showHealthcareInfo()
                return
            }
            
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
    
    private func showHealthcareInfo() {
        Task { @MainActor in
            try await remoteConfigManager.fetchAndActivate()
            guard
                !UserManager.shared.getShowHealthcare,
                remoteConfigManager.boolValue(for: .healthcareGuideVisible)
            else { return }
            
            UserManager.shared.setShowHealthcare()
            
            buildBottomSheet(
                height: screenHeight * 0.48 + 290,
                content: {
                    HomeHealthcareBSView()
                        .environment(self)
                }
            )
        }
    }
}

extension AppCoordinator {
    @ViewBuilder
    func makeScene(_ scene: AppScene) -> some View {
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
        case let .changeNickname(viewModel):
            diContainer.buildMypageChangeNicknameView(viewModel: viewModel)
        case .healthcarePermission:
            diContainer.buildHealthCarePermissionView(coordinator: self)
        case .healthcarePermissionDenied:
            diContainer.buildHealthCarePermissionDeniedView(coordinator: self)
        }
    }
}
