//
//  DefaultGetCharactersListUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/30/25.
//

import Combine

final class DefaultGetCharactersListUseCase: BaseCharactersUseCase, GetCharactersListUseCase {
    func getCharactersList() -> AnyPublisher<[CharacterEntity], NetworkError> {
        let dinoPublisher = characterRepository.getCharactersList(dummy: false, type: .dino)
        let jellyfishPublisher = characterRepository.getCharactersList(dummy: false, type: .jellyfish)
        return Publishers.CombineLatest(dinoPublisher, jellyfishPublisher)
            .map { dinoList, jellyfishList in
                return dinoList + jellyfishList
            }
            .mapToNetworkError()
    }
}
