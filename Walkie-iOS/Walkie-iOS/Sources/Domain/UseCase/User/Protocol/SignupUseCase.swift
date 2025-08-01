//
//  SignupUseCase.swift
//  Walkie-iOS
//
//  Created by 고아라 on 4/28/25.
//

import Combine

protocol SignupUseCase {
    
    func postSignup(
        info: LoginUserInfo
    ) -> AnyPublisher<TokenVO, NetworkError>
}
