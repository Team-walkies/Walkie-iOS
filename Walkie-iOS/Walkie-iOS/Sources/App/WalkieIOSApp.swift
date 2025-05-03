import SwiftUI
import KakaoSDKCommon
import BackgroundTasks

@main
struct WalkieIOSApp: App {
    @StateObject private var appCoordinator: AppCoordinator = AppCoordinator(diContainer: DIContainer.shared)
    @Environment(\.scenePhase) private var scenePhase
    
    private let checkStepUseCase = DIContainer.shared.resolveCheckStepUseCase()
    private let updateStepUseCase = DIContainer.shared.resolveUpdateStepUseCase()
    
    private enum BackgroundTaskIdentifier: String, CaseIterable {
        case checkStep = "com.walkie.ios.check.step"
        case updateStep = "com.walkie.ios.update.step"
    }
    
    init() {
        // Kakao SDK 초기화
        let kakaoNativeAppKey = (Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String) ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
        
        // 백그라운드 작업 등록
        registerBackgroundTasks()
    }
    
    var body: some Scene {
        WindowGroup {
            appCoordinator.buildScene(appCoordinator.currentScene)
                .environmentObject(appCoordinator)
                .onChange(of: scenePhase) { oldPhase, newPhase in
                    switch newPhase {
                    case .active:
                        print("[DEBUG][WalkieIOSApp][scenePhase] App became active")
                        executeForegroundTasks()
                    case .inactive:
                        print("[DEBUG][WalkieIOSApp][scenePhase] App became inactive")
                    case .background:
                        print("[DEBUG][WalkieIOSApp][scenePhase] App entered background")
                        executeBackgroundTasks()
                    @unknown default:
                        print("[DEBUG][WalkieIOSApp][scenePhase] Unknown phase")
                    }
                }
        }
    }
    
    // MARK: - Task Execution
    
    private func executeForegroundTasks() {
        print("[DEBUG][WalkieIOSApp][executeForegroundTasks] Executing UpdateStepUseCase...")
        updateStepUseCase.execute()
        print("[DEBUG][WalkieIOSApp][executeForegroundTasks] UpdateStepUseCase completed")
        
        print("[DEBUG][WalkieIOSApp][executeForegroundTasks] Executing CheckStepUseCase...")
        checkStepUseCase.execute()
        print("[DEBUG][WalkieIOSApp][executeForegroundTasks] CheckStepUseCase completed")
    }
    
    private func executeBackgroundTasks() {
        print("[DEBUG][WalkieIOSApp][executeBackgroundTasks] Executing UpdateStepUseCase...")
        updateStepUseCase.execute()
        print("[DEBUG][WalkieIOSApp][executeBackgroundTasks] UpdateStepUseCase completed")
        
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
        
        print("[DEBUG][WalkieIOSApp][registerBackgroundTasks] Background tasks registered")
    }
    
    private func handleCheckStepTask(task: BGTask) {
        print("[DEBUG][WalkieIOSApp][handleCheckStepTask] Starting checkStep background task")
        
        task.expirationHandler = {
            print("[DEBUG][WalkieIOSApp][handleCheckStepTask] CheckStep task expired")
            task.setTaskCompleted(success: false)
        }
        
        checkStepUseCase.execute()
        print("[DEBUG][WalkieIOSApp][handleCheckStepTask] CheckStepUseCase executed")
        
        task.setTaskCompleted(success: true)
        scheduleBackgroundTasks()
    }
    
    private func handleUpdateStepTask(task: BGTask) {
        print("[DEBUG][WalkieIOSApp][handleUpdateStepTask] Starting updateStep background task")
        
        task.expirationHandler = {
            print("[DEBUG][WalkieIOSApp][handleUpdateStepTask] UpdateStep task expired")
            task.setTaskCompleted(success: false)
        }
        
        updateStepUseCase.execute()
        print("[DEBUG][WalkieIOSApp][handleUpdateStepTask] UpdateStepUseCase executed")
        
        task.setTaskCompleted(success: true)
        scheduleBackgroundTasks()
    }
    
    private func scheduleBackgroundTasks() {
        let checkStepRequest = BGAppRefreshTaskRequest(identifier: BackgroundTaskIdentifier.checkStep.rawValue)
        checkStepRequest.earliestBeginDate = Date(timeIntervalSinceNow: 10)
        
        do {
            try BGTaskScheduler.shared.submit(checkStepRequest)
            print("[DEBUG][WalkieIOSApp][scheduleBackgroundTasks] CheckStep task scheduled")
        } catch {
            print("[DEBUG][WalkieIOSApp][scheduleBackgroundTasks] Failed to schedule CheckStep task: \(error)")
        }
        
        let updateStepRequest = BGAppRefreshTaskRequest(identifier: BackgroundTaskIdentifier.updateStep.rawValue)
        updateStepRequest.earliestBeginDate = Date(timeIntervalSinceNow: 10)
        
        do {
            try BGTaskScheduler.shared.submit(updateStepRequest)
            print("[DEBUG][WalkieIOSApp][scheduleBackgroundTasks] UpdateStep task scheduled")
        } catch {
            print("[DEBUG][WalkieIOSApp][scheduleBackgroundTasks] Failed to schedule UpdateStep task: \(error)")
        }
    }
}
