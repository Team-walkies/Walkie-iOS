//
//  DefaultGetCharactersListUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/30/25.
//

import Combine

final class DefaultGetCharactersListUseCase: BaseCharactersUseCase, GetCharactersListUseCase {
    func getCharactersList() -> AnyPublisher<[CharacterEntity], NetworkError> {
        characterRepository.getCharactersList(dummy: true, type: .dino)
            .mapToNetworkError()
    }
}
