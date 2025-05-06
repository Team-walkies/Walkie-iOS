//
//  CharacterRepository.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/29/25.
//

import Combine

protocol CharacterRepository {
    func getCharactersDetail(characterId: CLong) -> AnyPublisher<[CharacterDetailEntity], NetworkError>
    func getCharactersList(type: CharacterType) -> AnyPublisher<[CharacterEntity], NetworkError>
    func getCharactersCount() -> AnyPublisher<Int, NetworkError>
}
