//
//  DefaultPutHealthUseCase.swift
//  Walkie-iOS
//
//  Created by 고아라 on 8/18/25.
//

import Combine

final class DefaultPutHealthUseCase: BaseHealthUseCase, PutHealthUseCase {
    func putHealth(request: HealthRequestDto) -> AnyPublisher<Void, NetworkError> {
        healthRepository
            .putHealth(request: request)
            .mapToNetworkError()
    }
}
