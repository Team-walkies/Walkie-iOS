//
//  SignupViewModel.swift
//  Walkie-iOS
//
//  Created by 고아라 on 4/28/25.
//


import SwiftUI

import Combine

final class SignupViewModel: ViewModelable {
    
    // usecases
    
    private let signupUseCase: DefaultSignupUseCase
    
    enum Action {
        case tapSignup
    }
    
    struct SignupState: Equatable {
        let successSignup: Bool
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.successSignup == rhs.successSignup
        }
    }
    
    // view states
    
    enum SignupViewState: Equatable {
        case loading
        case loaded(SignupState)
        case error
    }
    
    @Published var state: SignupViewState = .loading
    private var cancellables = Set<AnyCancellable>()
    
    init (
        signupUseCase: DefaultSignupUseCase
    ) {
        self.signupUseCase = signupUseCase
    }
    
    func action(_ action: Action) {
        signup()
    }
}

extension SignupViewModel {
    
    func signup() {
        self.signupUseCase.postSignup(
            nickname: UserManager.shared.getUserNickname
        )
        .walkieSink(
            with: self,
            receiveValue: { _, tokenVO in
                do {
                    if let accessToken = tokenVO.accessToken, let refreshToken = tokenVO.refreshToken {
                        try TokenKeychainManager.shared.saveAccessToken(accessToken)
                        try TokenKeychainManager.shared.saveRefreshToken(refreshToken)
                        UserManager.shared.setTapStart()
                        self.state = .loaded(SignupState(successSignup: true))
                    }
                } catch {
                    self.state = .loaded(SignupState(successSignup: false))
                }
            }, receiveFailure: { _, _ in
                self.state = .error
            }
        )
        .store(in: &self.cancellables)
    }
}
