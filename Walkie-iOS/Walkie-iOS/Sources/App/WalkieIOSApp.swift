import SwiftUI

@main
struct WalkieIOSApp: App {
    
    @State var showSplash: Bool = false
    
    @State private var hasLogin: Bool = UserManager.shared.isUserLogin
    @State private var hasNickname: Bool = UserManager.shared.hasUserNickname
    @State private var isTapStart: Bool = UserManager.shared.isTapStart
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if !showSplash {
                    SplashView(showSplash: $showSplash)
                } else if !hasLogin {
                    LoginView()
                } else if !hasNickname {
                    NicknameView()
                } else if isTapStart {
                    TabBarView()
                } else {
                    OnboardingCompleteView()
                }
            }
        }
    }
}
