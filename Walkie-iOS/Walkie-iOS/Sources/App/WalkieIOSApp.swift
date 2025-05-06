import SwiftUI
import KakaoSDKCommon

@main
struct WalkieIOSApp: App {
    
    @StateObject private var appCoordinator: AppCoordinator = AppCoordinator(diContainer: DIContainer.shared)
    
    init() {
        _ = StepManager.shared
        NotificationManager.shared.requestAuthorization { granted in
            if granted && NotificationManager.shared.getNotificationMode() {
                NotificationManager.shared.scheduleNotification(title: "푸시 알림", body: "테스트")
            }
        }
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
