//
//  DefaultGetHealthContinueDayUseCase.swift
//  Walkie-iOS
//
//  Created by 고아라 on 8/18/25.
//

import Combine

final class DefaultGetHealthContinueDayUseCase: BaseHealthUseCase, GetHealthContinueDayUseCase {
    func getHealthContinueDay() -> AnyPublisher<Int, NetworkError> {
        healthRepository
            .getHealthContinueDay()
            .mapToNetworkError()
    }
}
