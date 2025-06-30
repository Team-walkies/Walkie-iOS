//
//  GetEventEggUseCase.swift
//  Walkie-iOS
//
//  Created by 고아라 on 6/30/25.
//

import Combine

protocol GetEventEggUseCase {
    func getEventEgg() -> AnyPublisher<EventEggEntity, NetworkError>
}
