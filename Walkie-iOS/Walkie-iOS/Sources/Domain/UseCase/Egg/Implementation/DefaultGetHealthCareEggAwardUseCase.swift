//
//  DefaultGetHealthCareEggAwardUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 10/8/25.
//

import Combine

final class DefaultGetHealthCareEggAwardUseCase: BaseEggUseCase, GetHealthCareEggAwardUseCase {
    func execute(
        latitude: Double,
        longitude: Double,
        dateString: String
    ) -> AnyPublisher<EggType, NetworkError> {
        eggRepository.getHealthCareEggAward(
            latitude: latitude,
            longitude: longitude,
            dateString: dateString
        ).mapToNetworkError()
    }
}
