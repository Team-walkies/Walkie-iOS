//
//  DefaultGetEventEggUseCase.swift
//  Walkie-iOS
//
//  Created by 고아라 on 6/30/25.
//

import Combine

final class DefaultGetEventEggUseCase: BaseEggUseCase, GetEventEggUseCase {
    
    func getEventEgg() -> AnyPublisher<EventEggEntity, NetworkError> {
        eggRepository.getEventEgg()
            .mapToNetworkError()
    }
}
