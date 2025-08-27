//
//  DefaultGetHealthDetailUseCase.swift
//  Walkie-iOS
//
//  Created by 고아라 on 8/19/25.
//

import Combine

final class DefaultGetHealthDetailUseCase: BaseHealthUseCase, GetHealthDetailUseCase {
    func getHealthDetail(
        searchDate: String
    ) -> AnyPublisher<HealthDetailEntity, NetworkError> {
        healthRepository
            .getHealthDetail(searchDate: searchDate)
            .mapToNetworkError()
    }
}
