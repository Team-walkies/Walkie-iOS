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
    func getCharactersDetail(dummy: Bool = false, characterId: CLong) -> AnyPublisher<[CharacterDetailEntity], NetworkError> {
        if dummy {
            let dummyData = Array(
                repeating:
                    CharacterDetailEntity(
                        obtainedPosition: "충청남도 논산시",
                        obtainedDate: "2025-03-01"),
                count: 20
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
            let dummyData: [CharacterEntity] = (0..<5).map { index in
                CharacterEntity(
                    type: type,
                    jellyfishType: type == .jellyfish ? JellyfishType.allCases.randomElement() : nil,
                    dinoType: type == .dino ? DinoType.allCases.randomElement() : nil,
                    count: Int.random(in: 0...3),
                    isWalking: Bool.random(),
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
                            type: type,
                            jellyfishType: self.mapCharacterType(
                                requestedType: type,
                                type: character.type,
                                rank: character.rank,
                                characterClass: character.characterClass
                            ) as? JellyfishType,
                            dinoType: self.mapCharacterType(
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

extension DefaultCharacterRepository {
    
    func mapCharacterType(
        requestedType: CharacterType,
        type: Int,
        rank: Int,
        characterClass: Int) -> (any CaseIterable)? {
        if requestedType == .jellyfish && type == 1 { return nil }
        let index = rank == 0 ? characterClass : characterClass + 5 + (rank - 1) * 2
        return type == 0 ? JellyfishType.allCases[index] : DinoType.allCases[index]
    }
}
