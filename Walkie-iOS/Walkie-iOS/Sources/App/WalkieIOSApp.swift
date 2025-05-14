import SwiftUI
import KakaoSDKCommon

@main
struct WalkieIOSApp: App {
    
    @StateObject private var appCoordinator: AppCoordinator = AppCoordinator(diContainer: DIContainer.shared)
    
    init() {
        _ = StepManager.shared
        NotificationManager.shared.clearBadge()
        let kakaoNativeAppKey = (Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String) ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
    }

    var body: some Scene {
        WindowGroup {
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
                        }
                    ) { fullScreenCover in
                        appCoordinator.buildFullScreenCover(fullScreenCover)
                            .environmentObject(appCoordinator)
                            .ignoresSafeArea(.all)
                            .presentationBackground(.black.opacity(0))
                    }
                    .transaction { $0.disablesAnimations = true }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
