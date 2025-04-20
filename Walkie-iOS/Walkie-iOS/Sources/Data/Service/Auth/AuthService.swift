//
//  AuthService.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import Combine

protocol AuthService {
    func kakaoLogin(loginAccessToken: String) -> AnyPublisher<LoginDto, NetworkError>
    func appleLogin(loginAccessToken: String) -> AnyPublisher<LoginDto, NetworkError>
    func logout() -> AnyPublisher<Void, NetworkError>
    func refreshAccessToken(refreshToken: String) -> AnyPublisher<RefreshAccessTokenDto, NetworkError>
}
