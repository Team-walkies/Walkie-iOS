//
//  DefaultSignupUseCase.swift
//  Walkie-iOS
//
//  Created by 고아라 on 4/28/25.
//

import Combine

final class DefaultSignupUseCase: BaseUserUseCase, SignupUseCase {
    
    func postSignup(
        info: LoginUserInfo
    ) -> AnyPublisher<TokenVO, NetworkError> {
        authRepository.signup(info: info)
            .mapToNetworkError()
    }
}
