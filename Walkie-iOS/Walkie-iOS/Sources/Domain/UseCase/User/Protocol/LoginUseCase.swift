//
//  LoginUseCase.swift
//  Walkie-iOS
//
//  Created by ahra on 4/26/25.
//

import Combine

protocol LoginUseCase {
    
    func postLogin(
        request: LoginRequestDto
    ) -> AnyPublisher<TokenVO, NetworkError>
}
