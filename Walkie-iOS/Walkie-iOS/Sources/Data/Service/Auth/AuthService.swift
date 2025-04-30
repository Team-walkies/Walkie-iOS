//
//  AuthService.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import Combine

protocol AuthService {
    func login(request: LoginRequestDto) -> AnyPublisher<LoginDto, Error>
    func logout() -> AnyPublisher<Void, Error>
    func signup(info: LoginUserInfo) -> AnyPublisher<LoginDto, Error>
}
