//
//  DefaultGetEggCountUseCase.swift
//  Walkie-iOS
//
//  Created by ahra on 4/2/25.
//

import Combine

final class DefaultGetEggCountUseCase: BaseEggUseCase, GetEggCountUseCase {
    
    func getEggsCount() -> AnyPublisher<Int, NetworkError> {
        eggRepository.getEggsCount()
            .mapToNetworkError()
    }
}
