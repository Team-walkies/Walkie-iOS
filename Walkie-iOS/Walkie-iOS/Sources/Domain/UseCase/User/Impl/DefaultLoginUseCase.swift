//
//  DefaultLoginUseCase.swift
//  Walkie-iOS
//
//  Created by ahra on 4/26/25.
//

import Combine

final class DefaultLoginUseCase: BaseUserUseCase, LoginUseCase {
    
    func postLogin(
        request: LoginRequestDto
    ) -> AnyPublisher<TokenVO, NetworkError> {
        authRepository.login(request: request)
            .mapToNetworkError()
    }
}
