//
//  LoginViewModel.swift
//  Walkie-iOS
//
//  Created by ahra on 4/26/25.
//

import SwiftUI

import Combine
import KakaoSDKUser

final class LoginViewModel: ViewModelable {
    
    // usecases
    
    private let loginUseCase: DefaultLoginUseCase
    
    enum Action {
        case tapKakaoLogin
        case tapAppleLogin
    }
    
    struct LoginState: Equatable {
        let isExistMember: Bool
        
        static func == (lhs: LoginState, rhs: LoginState) -> Bool {
            return lhs.isExistMember == rhs.isExistMember
        }
    }
    
    // view states
    
    enum LoginViewState: Equatable {
        case loading
        case loaded(LoginState)
        case error
    }
    
    @Published var state: LoginViewState = .loading
    private var cancellables = Set<AnyCancellable>()
    
    init (
        loginUseCase: DefaultLoginUseCase
    ) {
        self.loginUseCase = loginUseCase
    }
    
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
                        print("👌👌accessToken👌👌")
                        print(accessToken)
                        let loginRequestDto = LoginRequestDto(
                            provider: .kakao,
                            token: accessToken
                        )
                        self.sendLoginRequest(request: loginRequestDto)
                    }
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    print(error)
                } else {
                    if let accessToken = oauthToken?.accessToken {
                        let loginRequestDto = LoginRequestDto(
                            provider: .kakao,
                            token: accessToken
                        )
                        self.sendLoginRequest(request: loginRequestDto)
                    }
                }
            }
        }
    }
    
    func sendLoginRequest(request: LoginRequestDto) {
        print("👌👌sendLoginRequest👌👌")
        print(request)
        UserManager.shared.setSocialLogin(request: request)
        self.loginUseCase.postLogin(request: request)
            .walkieSink(
                with: self,
                receiveValue: { _, tokenVO in
                    do {
                        if let accessToken = tokenVO.accessToken, let refreshToken = tokenVO.refreshToken { // 기존회원
                            try TokenKeychainManager.shared.saveAccessToken(accessToken)
                            try TokenKeychainManager.shared.saveRefreshToken(refreshToken)
                            self.state = .loaded(LoginState(isExistMember: true))
                        } else { // 처음 가입
                            self.state = .loaded(LoginState(isExistMember: false))
                        }
                    } catch {
                        
                    }
                }, receiveFailure: { _, _ in
                    self.state = .error
                }
            )
            .store(in: &self.cancellables)
    }
    
    func appleLogin() {
    }
}
