//
//  DefaultGetHealthLastDataDayUseCase.swift
//  Walkie-iOS
//
//  Created by 고아라 on 8/25/25.
//

import Combine
import Foundation

final class DefaultGetHealthLastDataDayUseCase: BaseHealthUseCase, GetHealthLastDataDayUseCase {
    func getHealthLastDataDay() -> AnyPublisher<Date, NetworkError> {
        healthRepository
            .getHealthLastDataDay()
            .mapToNetworkError()
    }
}
