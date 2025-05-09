//
//  LoginViewModel.swift
//  Walkie-iOS
//
//  Created by ahra on 4/26/25.
//

import SwiftUI

import Combine
import KakaoSDKUser
import AuthenticationServices

final class LoginViewModel: NSObject, ViewModelable {
    
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
    var loginInfo: LoginUserInfo = LoginUserInfo(provider: .kakao, socialToken: "", username: "")
    
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
            
            UserApi.shared.me { user, error in
                if error != nil {
                    return
                }
                if let nickname = user?.kakaoAccount?.profile?.nickname {
                    print("👌👌카카오 닉네임👌👌", nickname)
                    self.loginInfo.username = nickname
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
            
            UserApi.shared.me { user, error in
                if error != nil {
                    return
                }
                if let nickname = user?.kakaoAccount?.profile?.nickname {
                    print("👌👌카카오 닉네임👌👌", nickname)
                    self.loginInfo.username = nickname
                }
            }
        }
    }
    
    func sendLoginRequest(request: LoginRequestDto) {
        print("👌👌sendLoginRequest👌👌")
        print(request)
        loginInfo.provider = request.provider
        loginInfo.socialToken = request.token
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
    
    func resetState() {
        state = .loading
        loginInfo = LoginUserInfo(provider: .kakao, socialToken: "", username: "")
        cancellables.removeAll()
    }
}

extension LoginViewModel: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    
    func appleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func authorizationController(
        controller _: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let fullName = appleIDCredential.fullName
            let idToken = appleIDCredential.identityToken!
            
            if let nameComponents = appleIDCredential.fullName {
                let fullNameString = nameComponents.formatted(.name(style: .long))
                self.loginInfo.username = fullNameString
            }
            
            if let tokenString = String(data: idToken, encoding: .utf8) {
                print(tokenString)
                let request = LoginRequestDto(provider: LoginType.apple, token: tokenString)
                self.sendLoginRequest(request: request)
            }
        default:
            break
        }
    }
    
    func presentationAnchor(
        for controller: ASAuthorizationController
    ) -> ASPresentationAnchor {
        return UIApplication.shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first { $0.isKeyWindow }
        ?? UIWindow()
    }
}
