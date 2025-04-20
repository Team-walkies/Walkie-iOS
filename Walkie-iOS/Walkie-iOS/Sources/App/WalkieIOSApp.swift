import SwiftUI

@main
struct WalkieIOSApp: App {
    
    @State var showSplash: Bool = false
    
    @State private var appCoordinator: AppCoordinator = AppCoordinator(diContainer: DIContainer.shared)
    
    @State private var hasLogin: Bool = UserManager.shared.isUserLogin
    @State private var hasNickname: Bool = UserManager.shared.hasUserNickname
    @State private var isTapStart: Bool = UserManager.shared.isTapStart
    @State private var isHatching: Bool = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if !showSplash {
                    appCoordinator.buildScene(.splash)
                } else if !hasLogin {
                    appCoordinator.buildScene(.login)
                } else if !hasNickname {
                    appCoordinator.buildScene(.nickname)
                } else if isTapStart {
                    appCoordinator.buildScene(.tabBar)
                } else {
                    appCoordinator.buildScene(.complete)
                }
            }
        }
    }
}
