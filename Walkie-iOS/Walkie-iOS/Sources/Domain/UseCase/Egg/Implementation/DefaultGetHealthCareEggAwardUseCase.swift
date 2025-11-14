//
//  DefaultGetHealthCareEggAwardUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 10/8/25.
//

import Combine

final class DefaultGetHealthCareEggAwardUseCase: BaseEggUseCase, GetHealthCareEggAwardUseCase {
    func execute(dateString: String) -> AnyPublisher<EggType, NetworkError> {
        eggRepository
            .getHealthCareEggAward(dateString: dateString)
            .mapToNetworkError()
    }
}
