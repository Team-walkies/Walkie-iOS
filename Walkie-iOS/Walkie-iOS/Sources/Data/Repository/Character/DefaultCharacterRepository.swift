//
//  DefaultCharacterRepository.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/29/25.
//

import Combine
import SwiftUICore

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
    func getCharactersDetail(
        dummy: Bool = false,
        characterId: CLong) -> AnyPublisher<[CharacterDetailEntity], NetworkError> {
        if dummy {
            let dummyData = Array(
                repeating:
                    CharacterDetailEntity(
                        obtainedPosition: "충청남도 논산시",
                        obtainedDate: "2025-03-01"),
                count: Int.random(in: 1...20)
            )
            return Just(dummyData)
                .setFailureType(to: NetworkError.self)
                .mapToNetworkError()
        } else {
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
    }
    
    func getCharactersList(dummy: Bool = false, type: CharacterType) -> AnyPublisher<[CharacterEntity], NetworkError> {
        if dummy {
            let dummyData: [CharacterEntity] = (0..<10).map { _ in
                let having = Bool.random()
                return CharacterEntity(
                    characterId: Int.random(in: 0...100),
                    type: type,
                    jellyfishType: type == .jellyfish ? JellyfishType.allCases.randomElement() : nil,
                    dinoType: type == .dino ? DinoType.allCases.randomElement() : nil,
                    count: having ? Int.random(in: 1...10) : 0,
                    isWalking: having ? Bool.random() : false,
                    obtainedDetails: nil
                )
            }
            return Just(dummyData)
                .setFailureType(to: NetworkError.self)
                .mapToNetworkError()
        } else {
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
    }
    
    func getCharactersCount(dummy: Bool = false) -> AnyPublisher<Int, NetworkError> {
        if dummy {
            return Just(Int.random(in: 0..<20))
                .setFailureType(to: NetworkError.self)
                .mapToNetworkError()
        } else {
            return characterService.getCharactersCount()
                .map { dto in
                    dto.charactersCount
                }.mapToNetworkError()
        }
    }
    
}
