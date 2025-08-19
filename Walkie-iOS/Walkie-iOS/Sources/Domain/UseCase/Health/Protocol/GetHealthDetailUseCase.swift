//
//  GetHealthDetailUseCase.swift
//  Walkie-iOS
//
//  Created by 고아라 on 8/19/25.
//

import Combine

protocol GetHealthDetailUseCase {
    func getHealthDetail(
        searchDate: String
    ) -> AnyPublisher<HealthDetailEntity, NetworkError>
}
