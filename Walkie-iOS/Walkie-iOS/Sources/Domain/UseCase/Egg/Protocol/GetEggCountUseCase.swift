//
//  GetEggCountUseCase.swift
//  Walkie-iOS
//
//  Created by ahra on 4/2/25.
//

import Combine

protocol GetEggCountUseCase {
    func getEggsCount() -> AnyPublisher<Int, NetworkError>
}
