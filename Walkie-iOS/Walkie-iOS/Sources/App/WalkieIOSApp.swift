import SwiftUI
import BackgroundTasks
import KakaoSDKCommon
import FirebaseCore

@main
struct WalkieIOSApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    private let backgroundTaskManager: BGTaskManager
    @StateObject private var appCoordinator: AppCoordinator = AppCoordinator(diContainer: DIContainer.shared)
    
    init() {
        self.backgroundTaskManager = BGTaskManager()
        NotificationManager.shared.clearBadge()
        let kakaoNativeAppKey = (Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String) ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
        
        // 백그라운드 작업 등록
        backgroundTaskManager.registerBackgroundTasks(.step) { [self] task in
            appCoordinator.handleStepRefresh(task: task)
        }
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                appCoordinator.buildScene(appCoordinator.currentScene)
                    .environmentObject(appCoordinator)
                    .fullScreenCover(
                        item: $appCoordinator.appFullScreenCover,
                        onDismiss: {
                            if let onDismiss = appCoordinator.fullScreenCoverOnDismiss {
                                onDismiss()
                                appCoordinator.fullScreenCoverOnDismiss = nil
                            }
                        },
                        content: { fullScreenCover in
                            appCoordinator.buildFullScreenCover(fullScreenCover)
                                .environmentObject(appCoordinator)
                                .ignoresSafeArea(.all)
                                .presentationBackground(.black.opacity(0))
                        }
                    )
                    .transaction { $0.disablesAnimations = true }
                ToastContainer()
                    .ignoresSafeArea(.all, edges: .bottom)
                    .frame(alignment: .bottom)
                    .zIndex(.infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: scenePhase) { _, newValue in
                switch newValue {
                case .active:
                    // 포그라운드 실시간 걸음 수 추적 시작
                    appCoordinator.startStepUpdates()
                    // 백그라운드 스케줄링 모두 취소
                    BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: WalkieBackgroundTask.step.rawValue)
                default:
                    // 포그라운드 실시간 걸음 수 추적 종료
                    appCoordinator.stopStepUpdates()
                    // 백그라운드 작업 스케줄링
                    backgroundTaskManager.scheduleAppRefresh(.step)
                }
            }
        }
    }
}
