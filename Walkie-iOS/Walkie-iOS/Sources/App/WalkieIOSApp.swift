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
                appCoordinator.buildScene(.hatchEgg)
                    .environmentObject(appCoordinator)
            }
        }
    }
}
