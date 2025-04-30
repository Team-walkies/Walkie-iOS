import SwiftUI
import KakaoSDKCommon

@main
struct WalkieIOSApp: App {
    
    @StateObject private var appCoordinator: AppCoordinator = AppCoordinator(diContainer: DIContainer.shared)
    
    init() {
        let kakaoNativeAppKey = (Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String) ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
    }

    var body: some Scene {
        WindowGroup {
            appCoordinator.buildScene(appCoordinator.currentScene)
                .environmentObject(appCoordinator)
        }
    }
}
