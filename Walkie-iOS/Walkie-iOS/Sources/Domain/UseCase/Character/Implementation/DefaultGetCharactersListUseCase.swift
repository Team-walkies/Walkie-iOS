//
//  DefaultGetCharactersListUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/30/25.
//

import Combine

final class DefaultGetCharactersListUseCase: BaseCharactersUseCase, GetCharactersListUseCase {
    func getCharactersList() -> AnyPublisher<[CharacterEntity], NetworkError> {
        let dinoPublisher = characterRepository.getCharactersList(type: .dino)
        let jellyfishPublisher = characterRepository.getCharactersList(type: .jellyfish)
        return Publishers.CombineLatest(dinoPublisher, jellyfishPublisher)
            .map { dinoList, jellyfishList in
                return dinoList + jellyfishList
            }
            .mapToNetworkError()
    }
}
