//
//  LogoutUserUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import Combine

protocol LogoutUserUseCase {
    func execute() -> AnyPublisher<Void, NetworkError>
}
