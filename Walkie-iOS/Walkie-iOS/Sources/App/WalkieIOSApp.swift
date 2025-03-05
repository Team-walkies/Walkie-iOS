import SwiftUI

@main
struct WalkieIOSApp: App {
    
    @State var showSplash: Bool = false
    
    // TODO: keychain 구현 후에 로컬 값으로 변경해야함
    @State var hasLogin: Bool = false
    @State var hasNickname: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if !showSplash { // 스플래시 안보여줌
                SplashView(showSplash: $showSplash)
            } else { // 스플래시 끝남
                if hasLogin { // 로그인은 했음
                    if hasNickname { // 닉네임도 지었음
                        TabBarView()
                    } else { // 닉네임은 안지음
                        NicknameView()
                    }
                } else { // 로그인 안했음
                    LoginView()
                }
            }
        }
    }
}
