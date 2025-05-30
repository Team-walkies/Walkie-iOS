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
    
    var tabBarView: AnyView?
    
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
        initialize()
    }
    
    func initialize() {
        self.tabBarView = AnyView(
            TabBarView(
                homeCoordinator: HomeCoordinator(diContainer: self.diContainer, appCoordinator: self),
                mypageCoordinator: MypageCoordinator(diContainer: self.diContainer)
            )
        )
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
    
    // MARK: - Background 걸음 수 측정
    func handleStepRefresh(task: BGAppRefreshTask) {
        task.expirationHandler = {
            print("⏳ 백그라운드 테스크 만료 ⏳")
            task.setTaskCompleted(success: false)
        }
        guard let needStep = stepStatusStore.needStep, needStep <= 10000 else {
            task.setTaskCompleted(success: true)
            print("⏳ 백그라운드 걸음 수 안함 : 알 없음 ⏳")
            return
            // 알 없는 경우 백그라운드 테스크 스케줄링 X
        }
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
    
    // MARK: - Foreground 걸음 수 측정
    func startStepUpdates() {
        stopStepUpdates()
        print("🏃 cancellables 수: \(cancellables.count) 🏃")
        getEggPlayUseCase.execute() // 1. 같이 걷는 알 조회
            .walkieSink(
                with: self,
                receiveValue: { [weak self] _, data in
                    guard let self = self else { return }
                    updateStepForegroundUseCase.start() // 2. 걸음 수 쿼리 및 업데이트 시작
                        .receive(on: DispatchQueue.main)
                        .sink(
                            receiveCompletion: { completion in
                                if case let .failure(error) = completion {
                                    print("🏃 updateStepForegroundUseCase 에러: \(error.localizedDescription) 🏃")
                                }
                            },
                            receiveValue: { _ in
                                // 업데이트 이벤트 수신
                                if self.checkHatchConditionUseCase.execute() { // 3. 부화 조건 검사
                                    // 4-a. 부화 처리
                                    self.presentFullScreenCover(AppFullScreenCover.hatchEgg)
                                    // 홈뷰 알 없는 상태로 뷰 업데이트
                                    self.hatchSubject.send(true)
                                    // 걸음 수 쿼리 종료
                                    self.stopStepUpdates()
                                } else {
                                    let newStep = self.stepStatusStore.getNowStep()
                                    // 4-b. 서버에 업데이트
                                    self.updateEggStepUseCase.execute(
                                        egg: data,
                                        step: newStep,
                                        willHatch: false) {
                                            // 홈뷰 남은 걸음 수 업데이트를 위한 이벤트 방출
                                            self.hatchSubject.send(false)
                                        }
                                }
                            }
                        ).store(in: &cancellables)
                }, receiveFailure: { _, error in
                    print("🥚 같이 걷는 알 가져오기 실패 : \(String(describing: error?.localizedDescription))🥚")
                    self.stopStepUpdates() // 알이 없는 경우 업데이트 중지
                    return
                }
            ).store(in: &cancellables)
    }
    
    func stopStepUpdates() {
        updateStepForegroundUseCase.stop()
        cancellables.removeAll()
    }
}
