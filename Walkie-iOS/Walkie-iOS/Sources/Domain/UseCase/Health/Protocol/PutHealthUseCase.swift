//
//  PutHealthUseCase.swift
//  Walkie-iOS
//
//  Created by 고아라 on 8/18/25.
//

import Combine

protocol PutHealthUseCase {
    func putHealth(request: HealthRequestDto) -> AnyPublisher<Void, NetworkError>
}
