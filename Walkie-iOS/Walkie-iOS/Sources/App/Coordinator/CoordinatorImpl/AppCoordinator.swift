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
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Foreground 걸음 수 측정
    /// 뷰 업데이트를 위한 Publisher입니다.
    private let hatchSubject = PassthroughSubject<Bool, Error>()
    /// 각 뷰에서 stepPublisher를 구독하여 이벤트를 방출 받습니다.
    var hatchPublisher: AnyPublisher<Bool, Error> {
        hatchSubject.share().eraseToAnyPublisher()
    }
    
    // MARK: - UseCases
    private let getEggPlayUseCase = DIContainer.shared.resolveGetEggPlayUseCase()
    private let updateStepForegroundUseCase = DIContainer.shared.resolveUpdateStepForegroundUseCase()
    private let checkHatchConditionUseCase = DIContainer.shared.resolveCheckHatchConditionUseCase()
    private let updateEggStepUseCase = DIContainer.shared.resolveUpdateEggStepUseCase()
    private let updateStepBackgroundUseCase = DIContainer.shared.resolveUpdateStepBackgroundUseCase()
    private let stepStatusStore = DIContainer.shared.stepStatusStore
    
    init(diContainer: DIContainer) {
        self.diContainer = diContainer
        startSplash()
        
        NotificationCenter.default
            .publisher(for: .reissueFailed)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.changeToSplash()
            }
            .store(in: &cancellables)
            
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
    
    private func startSplash() {
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
}

// MARK: - Background 걸음 수 측정
extension AppCoordinator {
    func handleStepRefresh(task: BGAppRefreshTask) {
        task.expirationHandler = {
            print("⏳ 백그라운드 테스크 만료 ⏳")
            task.setTaskCompleted(success: false)
        }
        
        guard let needStep = stepStatusStore.needStep, needStep <= 10000 else {
            task.setTaskCompleted(success: true)
            print("⏳ 백그라운드 걸음 수 업데이트 및 스케줄링 하지 않음 : 알 없음 ⏳")
            return
            // 알 없는 경우 백그라운드 테스크 스케줄링 X
        }
        
        // 백그라운드 작업 수행
        updateStepBackgroundUseCase.execute()
        print("⏳ 백그라운드 걸음 수 업데이트 완료 ⏳")
        task.setTaskCompleted(success: true)
        
        /// 다음 작업 스케줄링
        if checkHatchConditionUseCase.execute() {
            /// 푸시알림 전송
            print("⏳ 백그라운드 걸음 수 업데이트 스케줄링 중단 : 부화 조건 달성, 푸시 알림 전송 ⏳")
            NotificationManager.shared.scheduleNotification(
                title: NotificationLiterals.eggHatch.title,
                body: NotificationLiterals.eggHatch.body
            )
        } else {
            /// 부화 조건이 아닌 경우 다시 백그라운드 테스크 스케줄링
            print("⏳ 백그라운드 걸음 수 업데이트 스케줄링 ⏳")
            BGTaskManager.shared.scheduleAppRefresh(.step)
        }
    }
}

// MARK: - Foreground 걸음 수 측정
extension AppCoordinator {
    /// 같이 걷는 알을 조회하고 결과를 처리합니다.
    func fetchEggPlay(completion: @escaping (Result<EggEntity, Error>) -> Void) {
        getEggPlayUseCase.execute()
            .walkieSink(
                with: self,
                receiveValue: { _, egg in
                    print("🥚 같이 걷는 알 가져오기 성공 🥚")
                    dump(egg)
                    completion(.success(egg))
                },
                receiveFailure: { _, error in
                    print("🥚 같이 걷는 알 가져오기 실패 : \(String(describing: error?.localizedDescription))🥚")
                    completion(.failure(error ?? .emptyDataError))
                }
            )
            .store(in: &cancellables)
    }
    
    /// 걸음 수 쿼리를 시작하고 업데이트 이벤트를 처리합니다.
    func startStepQuery(onUpdate: @escaping () -> Void) {
        updateStepForegroundUseCase.start()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("🏃 포그라운드 걸음 수 쿼리 실패 : \(error.localizedDescription) 🏃")
                    }
                },
                receiveValue: { _ in
                    onUpdate()
                }
            )
            .store(in: &cancellables)
    }
    
    /// 부화 조건을 확인하고 결과를 반환합니다.
    func checkHatchCondition() -> Bool {
        checkHatchConditionUseCase.execute()
    }
    
    /// 알 부화 화면을 표시합니다.
    func presentHatchEggScreen() {
        presentFullScreenCover(AppFullScreenCover.hatchEgg)
        hatchSubject.send(true)
        stopStepUpdates()
    }
    
    /// Foreground 걸음 수 업데이트 시작
    func startStepUpdates() {
        stopStepUpdates() // 기존 쿼리 정리
        fetchEggPlay { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let egg):
                startStepQuery { [weak self] in
                    guard let self = self else { return }
                    let newStep = self.stepStatusStore.getNowStep()
                    
                    if self.checkHatchCondition() {
                        self.presentHatchEggScreen()
                    } else {
                        self.updateEggStepUseCase.execute(egg: egg, step: newStep, willHatch: false) {
                            self.hatchSubject.send(false)
                        }
                    }
                }
            case .failure:
                self.stopStepUpdates()
            }
        }
    }
    
    /// Foreground 걸음 수 업데이트 종료 및 구독 제거
    func stopStepUpdates() {
        updateStepForegroundUseCase.stop()
        cancellables.removeAll()
    }
}
