//
//  DefaultGetCharactersDetailUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/30/25.
//

import Combine

final class DefaultGetCharactersDetailUseCase: BaseCharactersUseCase, GetCharactersDetailUseCase {
    
    func getCharactersObtainedDetail(
        characterId: Int
    ) -> AnyPublisher<CharacterDetailEntity, NetworkError> {
        characterRepository
            .getCharactersDetail(characterId: characterId)
            .mapToNetworkError()
    }
}
