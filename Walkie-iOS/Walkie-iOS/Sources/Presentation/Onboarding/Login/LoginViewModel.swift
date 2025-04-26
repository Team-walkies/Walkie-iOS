//
//  LoginViewModel.swift
//  Walkie-iOS
//
//  Created by ahra on 4/26/25.
//

import SwiftUI

import KakaoSDKUser

final class LoginViewModel: ViewModelable {
    
    enum Action {
        case tapKakaoLogin
        case tapAppleLogin
    }
    
    struct LoginState {
        let todayStep, leftStep: Int
        let todayDistance: Double
        let locationAlwaysAuthorized: Bool
    }
    
    // view states
    
    enum LoginViewState {
        case loading
        case loaded(LoginState)
        case error
    }
    
    @Published var state: LoginViewState = .loading
    
    func action(_ action: Action) {
        switch action {
        case .tapKakaoLogin:
            kakaoLogin()
        case .tapAppleLogin:
            appleLogin()
        }
    }
}

extension LoginViewModel {
    
    func kakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    print(error)
                } else {
                    if let accessToken = oauthToken?.accessToken {
                        print("👌👌👌👌")
                        print(accessToken)
                        print("👌👌👌👌")
                    }
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    print(error)
                } else {
                    if let accessToken = oauthToken?.accessToken {
                        print("👌👌👌👌")
                        print(accessToken)
                        print("👌👌👌👌")
                    }
                }
            }
        }
    }
    
    func appleLogin() {
        
    }
}
