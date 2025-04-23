import SwiftUI

@main
struct WalkieIOSApp: App {
    
    @State private var appCoordinator: AppCoordinator = AppCoordinator(diContainer: DIContainer.shared)

    var body: some Scene {
        WindowGroup {
            appCoordinator.buildScene(appCoordinator.currentScene)
        }
    }
}
