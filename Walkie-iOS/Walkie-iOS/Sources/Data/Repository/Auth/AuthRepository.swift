//
//  AuthRepository.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import Combine

protocol AuthRepository {
    func login(request: LoginRequestDto) -> AnyPublisher<TokenVO, NetworkError>
    func logout() -> AnyPublisher<Void, NetworkError>
    func signup(nickname: String) -> AnyPublisher<TokenVO, NetworkError>
}
