//
//  SpalshView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/13/25.
//

import SwiftUI

struct SplashView: View {
    
    var body: some View {
        ZStack {
            Image(.imgLogoVertical)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showSplash = true
                        
                        print("🌀🌀🌀🌀userinfo🌀🌀🌀🌀")
                        do {
                            let token = try TokenKeychainManager.shared.getAccessToken()
                            print(token ?? "no token")
                        } catch {
                            print("issue;;")
                        }
                        print("isUserLogin")
                        print(UserManager.shared.isUserLogin)
                        print("nickname")
                        print(UserManager.shared.userNickname ?? "no nickname")
                        print("tapstart")
                        print(UserManager.shared.tapStart ?? false)
                    }
                }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
