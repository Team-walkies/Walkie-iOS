//
//  CharacterRepository.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/29/25.
//

import Combine

protocol CharacterRepository {
    func getCharactersDetail(dummy: Bool, characterId: CLong) -> AnyPublisher<[CharacterDetailEntity], NetworkError>
    func getCharactersList(dummy: Bool, type: CharacterType) -> AnyPublisher<[CharacterEntity], NetworkError>
    func getCharactersCount(dummy: Bool) -> AnyPublisher<Int, NetworkError>
}
