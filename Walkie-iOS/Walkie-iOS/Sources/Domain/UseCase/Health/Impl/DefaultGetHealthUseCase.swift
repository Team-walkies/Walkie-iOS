//
//  DefaultGetHealthUseCase.swift
//  Walkie-iOS
//
//  Created by 고아라 on 8/19/25.
//

import Combine

final class DefaultGetHealthUseCase: BaseHealthUseCase, GetHealthUseCase {
    func getHealth(
        date: HealthDateDto
    ) -> AnyPublisher<[String: HealthWeekEntity], NetworkError> {
        healthRepository
            .getHealth(param: date)
            .mapToNetworkError()
    }
}
