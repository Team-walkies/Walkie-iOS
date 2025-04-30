//
//  DefaultLogoutUserUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import Combine

final class DefaultLogoutUserUseCase: BaseUserUseCase, LogoutUserUseCase {
    
    func postLogout() -> AnyPublisher<Void, NetworkError> {
        authRepository.logout()
            .mapToNetworkError()
    }
}
