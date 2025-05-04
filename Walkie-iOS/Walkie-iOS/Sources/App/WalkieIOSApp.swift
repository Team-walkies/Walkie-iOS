import SwiftUI
import Combine
import KakaoSDKCommon
import BackgroundTasks

@main
struct WalkieIOSApp: App {
    @StateObject private var appCoordinator: AppCoordinator = AppCoordinator(diContainer: DIContainer.shared)
    @Environment(\.scenePhase) private var scenePhase

    private let checkStepUseCase = DIContainer.shared.resolveCheckStepUseCase()
    private let updateStepUseCase = DIContainer.shared.resolveUpdateStepCacheUseCase()
    private let updateEggStepUseCase = DIContainer.shared.resolveUpdateEggStepUseCase()
    private let getEggPlayUseCase = DIContainer.shared.resolveGetEggPlayUseCase()
    
    private enum BackgroundTaskIdentifier: String, CaseIterable {
        case checkStep = "com.walkie.ios.check.step"
        case updateStep = "com.walkie.ios.update.step"
    }
    
    @State private var willHatch: Bool = false
    
    init() {
        let kakaoNativeAppKey = (Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String) ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
        // 백그라운드 작업 등록
        registerBackgroundTasks()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                appCoordinator.buildScene(appCoordinator.currentScene)
                    .environmentObject(appCoordinator)
                    .onChange(of: scenePhase) { _, newPhase in
                        switch newPhase {
                        case .active:
                            /// 목표치 확인
                            /// 그동안의 걸음 수 서버에 업데이트
                            /// 가능한 경우 알 부화
                            executeForegroundTasks()
                        case .inactive:
                            break
                        case .background:
                            /// 걸음 수 업데이트
                            /// 목표치 확인
                            /// 목표치 도달 시 로컬 푸시알림 전송
                            executeBackgroundTasks()
                        @unknown default:
                            fatalError()
                        }
                    }
                if willHatch {
                    appCoordinator.buildScene(.hatchEgg)
                        .zIndex(.infinity)
                }
            }
            .ignoresSafeArea(.all)
        }
    }
    
    // MARK: - Task Execution
    private func executeForegroundTasks() {
        updateStepUseCase.execute()
        checkStepUseCase.execute()
        willHatch = UserManager.shared.getStepCount >= UserManager.shared.getStepCountGoal
        if willHatch {
            print("--- 알 부화 ---")
            UserManager.shared.setStepCount(0)
        } else {
            getEggPlayingAndThenUpdateStep()
        }
    }
    
    // 부화하지 않고 걸음 수 업데이트만 하는 경우
    // 부화하는 경우 HatchEggViewModel에서 처리
    private func getEggPlayingAndThenUpdateStep() {
        var cancellables: Set<AnyCancellable> = []
        getEggPlayUseCase.execute()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("EggEntity 조회 완료")
                case .failure(let error):
                    print("EggEntity 조회 오류: \(error)")
                }
            }, receiveValue: { eggEntityValue in
                self.updateEggStepUseCase.execute(
                    egg: eggEntityValue,
                    step: UserManager.shared.getStepCount,
                    willHatch: false
                )
            })
            .store(in: &cancellables)
    }
    
    private func executeBackgroundTasks() {
        updateStepUseCase.execute()
        checkStepUseCase.execute()
        scheduleBackgroundTasks()
    }
    
    // MARK: - Background Task Scheduling
    
    private func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: BackgroundTaskIdentifier.checkStep.rawValue,
            using: nil
        ) { task in
            self.handleCheckStepTask(task: task)
        }
        
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: BackgroundTaskIdentifier.updateStep.rawValue,
            using: nil
        ) { task in
            self.handleUpdateStepTask(task: task)
        }
    }
    
    private func handleCheckStepTask(task: BGTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        checkStepUseCase.execute()
        task.setTaskCompleted(success: true)
        scheduleBackgroundTasks()
    }
    
    private func handleUpdateStepTask(task: BGTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        updateStepUseCase.execute()
        task.setTaskCompleted(success: true)
        scheduleBackgroundTasks()
    }
    
    private func scheduleBackgroundTasks() {
        let checkStepRequest = BGAppRefreshTaskRequest(identifier: BackgroundTaskIdentifier.checkStep.rawValue)
        checkStepRequest.earliestBeginDate = Date(timeIntervalSinceNow: 10)
        
        do {
            try BGTaskScheduler.shared.submit(checkStepRequest)
        } catch {
            print("[DEBUG][WalkieIOSApp][scheduleBackgroundTasks] Failed to schedule CheckStep task: \(error)")
        }
        
        let updateStepRequest = BGAppRefreshTaskRequest(identifier: BackgroundTaskIdentifier.updateStep.rawValue)
        updateStepRequest.earliestBeginDate = Date(timeIntervalSinceNow: 10)
        
        do {
            try BGTaskScheduler.shared.submit(updateStepRequest)
        } catch {
            print("[DEBUG][WalkieIOSApp][scheduleBackgroundTasks] Failed to schedule UpdateStep task: \(error)")
        }
    }
}
