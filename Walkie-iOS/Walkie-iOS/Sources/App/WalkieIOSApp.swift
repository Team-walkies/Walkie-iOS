import SwiftUI
import BackgroundTasks
import KakaoSDKCommon
import FirebaseCore

@main
struct WalkieIOSApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var appCoordinator: AppCoordinator = AppCoordinator(diContainer: DIContainer.shared)
    
    init() {
        NotificationManager.shared.clearBadge()
        let kakaoNativeAppKey = (Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String) ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
        
        // 백그라운드 작업 등록
        BGTaskManager.shared.registerBackgroundTasks(.step) { [self] task in
            appCoordinator.handleStepRefresh(task: task)
        }
        
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appCoordinator.path) {
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
                .navigationDestination(for: AppScene.self) { scene in
                    appCoordinator.buildScene(scene)
                        .environmentObject(appCoordinator)
                        .navigationBarBackButtonHidden()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: scenePhase) { _, newValue in
                switch newValue {
                case .background:
                    appCoordinator.executeBackgroundActions()
                default:
                    break
                }
            }
        }
    }
}
