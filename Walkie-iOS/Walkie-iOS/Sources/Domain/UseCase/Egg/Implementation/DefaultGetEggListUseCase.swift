//
//  DefaultGetEggListUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 10/8/25.
//

import Combine

final class DefaultGetEggListUseCase: BaseEggUseCase, GetEggListUseCase {
    
    func execute() -> AnyPublisher<[(EggEntity, EggDetailEntity)], NetworkError> {
        eggRepository.getEggsList()
            .mapToNetworkError()
    }
}
