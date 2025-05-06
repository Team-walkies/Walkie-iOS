//
//  DefaultCharacterRepository.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/29/25.
//

import Combine

final class DefaultCharacterRepository {
    
    // MARK: - Dependency
    
    private let characterService: CharacterService
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(characterService: CharacterService) {
        self.characterService = characterService
    }
}

extension DefaultCharacterRepository: CharacterRepository {
    func getCharactersDetail(characterId: CLong) -> AnyPublisher<[CharacterDetailEntity], NetworkError> {
        return characterService.getCharactersDetail(characterId: characterId)
            .map { dto in
                dto.obtainedDetails.map { detail in
                    CharacterDetailEntity(
                        obtainedPosition: detail.obtainedPosition,
                        obtainedDate: detail.obtainedDate
                    )
                }
            }.mapToNetworkError()
    }
    
    func getCharactersList(type: CharacterType) -> AnyPublisher<[CharacterEntity], NetworkError> {
        return characterService.getCharactersList(type: type == .jellyfish ? 0 : 1)
            .map { dto in
                dto.characters.map { character in
                    CharacterEntity(
                        characterId: character.characterId,
                        type: type,
                        jellyfishType: CharacterType.mapCharacterType(
                            requestedType: type,
                            type: character.type,
                            rank: character.rank,
                            characterClass: character.characterClass
                        ) as? JellyfishType,
                        dinoType: CharacterType.mapCharacterType(
                            requestedType: type,
                            type: character.type,
                            rank: character.rank,
                            characterClass: character.characterClass
                        ) as? DinoType,
                        count: character.count,
                        isWalking: character.picked,
                        obtainedDetails: nil
                    )
                }
            }.mapToNetworkError()
    }
    
    func getCharactersCount() -> AnyPublisher<Int, NetworkError> {
        return characterService.getCharactersCount()
            .map { dto in
                dto.charactersCount
            }.mapToNetworkError()
    }
    
}
