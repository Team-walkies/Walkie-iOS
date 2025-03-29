//
//  CharacterService.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/29/25.
//

import Combine

protocol CharacterService {
    func getCharactersDetail(characterId: Int) -> AnyPublisher<GetCharactersDetailDto, Error>
    func getCharactersList(type: Int) -> AnyPublisher<GetCharactersListDto, Error>
    func getCharactersCount() -> AnyPublisher<GetCharactersCountDto, Error>
}
