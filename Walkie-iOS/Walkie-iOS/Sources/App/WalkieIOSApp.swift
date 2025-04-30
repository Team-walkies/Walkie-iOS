import SwiftUI

@main
struct WalkieIOSApp: App {
    
    @StateObject private var appCoordinator: AppCoordinator = AppCoordinator(diContainer: DIContainer.shared)

    var body: some Scene {
        WindowGroup {
            appCoordinator.buildScene(appCoordinator.currentScene)
                .environmentObject(appCoordinator)
        }
    }
}
