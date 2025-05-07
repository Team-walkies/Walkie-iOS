//
//  WithdrawUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/5/25.
//

import Combine

protocol WithdrawUseCase {
    func execute() -> AnyPublisher<Void, NetworkError>
}
