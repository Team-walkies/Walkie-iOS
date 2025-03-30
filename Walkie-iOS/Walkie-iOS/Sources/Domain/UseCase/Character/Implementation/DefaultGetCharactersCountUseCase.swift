//
//  DefaultGetCharactersCountUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/30/25.
//

import Combine

final class DefaultGetCharactersCountUseCase: BaseCharactersUseCase, GetCharactersCountUseCase {
    func getCharactersCount() -> AnyPublisher<Int, NetworkError> {
        characterRepository.getCharactersCount(dummy: false)
            .mapToNetworkError()
    }
}
