//
//  DefaultAuthService.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import Moya

import Combine
import CombineMoya

final class DefaultAuthService {
    
    private let authProvider: MoyaProvider<AuthTarget>
    
    init(authProvider: MoyaProvider<AuthTarget> = MoyaProvider<AuthTarget>(plugins: [NetworkLoggerPlugin()])) {
        self.authProvider = authProvider
    }
}

extension DefaultAuthService: AuthService {
    
    func login(request: LoginRequestDto) -> AnyPublisher<LoginDto, Error> {
        authProvider.requestPublisher(.login(request: request))
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(LoginDto.self)
    }
    
    func logout() -> AnyPublisher<LogoutDto, Error> {
        authProvider.requestPublisher(.logout)
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(LogoutDto.self)
    }
    
    func refreshAccessToken(refreshToken: String) -> AnyPublisher<RefreshAccessTokenDto, Error> {
        authProvider.requestPublisher(.refreshAccessToken(refreshToken: refreshToken))
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(RefreshAccessTokenDto.self)
    }
}
