import SwiftUI
import KakaoSDKCommon
import FirebaseCore

@main
struct WalkieIOSApp: App {
    
    @StateObject private var appCoordinator: AppCoordinator = AppCoordinator(diContainer: DIContainer.shared)
    
    init() {
        _ = StepManager.shared
        NotificationManager.shared.clearBadge()
        let kakaoNativeAppKey = (Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String) ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appCoordinator.path) {
                ZStack {
                    appCoordinator.buildScene(appCoordinator.currentScene)
                        .environmentObject(appCoordinator)
                        .fullScreenCover(
                            item: Binding(
                                get: { appCoordinator.appFullScreenCover },
                                set: { appCoordinator.appFullScreenCover = $0 }
                            ),
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
        }
    }
}
