//
//  GetEggPlayUseCase.swift
//  Walkie-iOS
//
//  Created by ahra on 4/1/25.
//

import Combine

protocol GetEggPlayUseCase {
    func execute() -> AnyPublisher<EggEntity, NetworkError>
}
