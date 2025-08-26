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
                        .bottomSheet(
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
                if let fullScreenCover = appCoordinator.appFullScreenCover {
                    appCoordinator.makeFullScreenCover(fullScreenCover)
                        .ignoresSafeArea(.all)
                }
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
        BGTaskManager.shared.registerBackgroundTasks(.step) { [self] task in
            appCoordinator.handleStepRefresh(task: task)
        }
    }
}
