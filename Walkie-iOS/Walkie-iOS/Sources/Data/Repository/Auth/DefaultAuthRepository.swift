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
    func kakaoLogin(loginAccessToken: String) -> AnyPublisher<TokenVO, NetworkError> {
        authService.kakaoLogin(loginAccessToken: loginAccessToken)
            .map { dto in
                TokenVO(accessToken: dto.accessToken, refreshToken: dto.refreshToken)
            }
            .mapToNetworkError()
    }
    
    func appleLogin(loginAccessToken: String) -> AnyPublisher<TokenVO, NetworkError> {
        authService.appleLogin(loginAccessToken: loginAccessToken)
            .map { dto in
                TokenVO(accessToken: dto.accessToken, refreshToken: dto.refreshToken)
            }
            .mapToNetworkError()
    }
    
    func logout() -> AnyPublisher<Void, NetworkError> {
        authService.logout()
            .map { _ in
                return
            }.mapToNetworkError()
    }
    
    func refreshAccessToken(refreshToken: String) -> AnyPublisher<TokenVO, NetworkError> {
        authService.refreshAccessToken(refreshToken: refreshToken)
            .map { dto in
                TokenVO(accessToken: dto.accessToken, refreshToken: dto.refreshToken)
            }
            .mapToNetworkError()
    }
}
