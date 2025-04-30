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
    
    private let reissueService: DefaultReissueService
    
    init(
        authProvider: MoyaProvider<AuthTarget> = MoyaProvider<AuthTarget>(plugins: [NetworkLoggerPlugin()]),
        reissueService: DefaultReissueService
    ) {
        self.authProvider = authProvider
        self.reissueService = reissueService
    }
}

extension DefaultAuthService: AuthService {
    
    func login(request: LoginRequestDto) -> AnyPublisher<LoginDto, Error> {
        authProvider.requestPublisher(.login(request: request))
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(LoginDto.self)
    }
    
    func logout() -> AnyPublisher<LogoutDto, Error> {
        authProvider
            .requestPublisher(
                .logout,
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(LogoutDto.self)
    }
    
    func signup(info: LoginUserInfo) -> AnyPublisher<LoginDto, any Error> {
        authProvider.requestPublisher(.signup(info: info))
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(LoginDto.self)
    }
}
