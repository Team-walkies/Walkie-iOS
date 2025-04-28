//
//  DefaultAuthRepository.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import Combine

final class DefaultAuthRepository {
    
    // MARK: - Dependency
    
    private let authService: AuthService
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(authService: AuthService) {
        self.authService = authService
    }
}

extension DefaultAuthRepository: AuthRepository {
    
    func login(
        request: LoginRequestDto
    ) -> AnyPublisher<TokenVO, NetworkError> {
        authService.login(request: request)
            .map { dto in
                TokenVO(
                    accessToken: dto.accessToken,
                    refreshToken: dto.refreshToken
                )
            }
            .mapToNetworkError()
    }
    
    func logout() -> AnyPublisher<Void, NetworkError> {
        authService.logout()
            .map { _ in
                return
            }.mapToNetworkError()
    }
    
    func signup(nickname: String) -> AnyPublisher<TokenVO, NetworkError> {
        authService.signup(nickname: nickname)
            .map { dto in
                TokenVO(
                    accessToken: dto.accessToken,
                    refreshToken: dto.refreshToken
                )
            }
            .mapToNetworkError()
    }
}
