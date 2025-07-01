import SwiftUI
import BackgroundTasks
import KakaoSDKCommon
import FirebaseCore

@main
struct WalkieIOSApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appCoordinator: AppCoordinator = AppCoordinator(diContainer: DIContainer.shared)
    
    init() {
        NotificationManager.shared.clearBadge()
        let kakaoNativeAppKey = (Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String) ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
        initiateBackgroundTask()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack(path: $appCoordinator.path) {
                    appCoordinator.buildScene(appCoordinator.currentScene)
                        .environmentObject(appCoordinator)
                        .navigationDestination(for: AppScene.self) { scene in
                            appCoordinator.buildScene(scene)
                                .environmentObject(appCoordinator)
                                .navigationBarBackButtonHidden()
                        }
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
                        .permissionBottomSheet(
                            isPresented: Binding(
                                get: { appCoordinator.sheet != nil },
                                set: {
                                    if !$0 { appCoordinator.dismissSheet() }
                                }
                            ),
                            height: appCoordinator.appSheet?.height ?? 0
                        ) {
                            appCoordinator.appSheet?.view
                        }
                }
                ToastContainer()
                    .ignoresSafeArea(.all, edges: .bottom)
                    .frame(alignment: .bottom)
                    .zIndex(.infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onChange(of: scenePhase) { _, newValue in
            switch newValue {
            case .background:
                appCoordinator.executeBackgroundActions()
            default:
                break
            }
        }
    }
    
    private func initiateBackgroundTask() {
        // 백그라운드 작업 등록
        BGTaskManager.shared.registerBackgroundTasks(.step) { [self] task in
            appCoordinator.handleStepRefresh(task: task)
        }
    }
}
