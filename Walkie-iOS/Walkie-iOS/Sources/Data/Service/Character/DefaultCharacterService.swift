//
//  DefaultCharacterService.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/29/25.
//

import Moya
import Combine
import CombineMoya

final class DefaultCharacterService {
    
    private let characterProvider: MoyaProvider<CharacterTarget>
    
    init(characterProvider: MoyaProvider<CharacterTarget> = MoyaProvider<CharacterTarget>(
        plugins: [NetworkLoggerPlugin()])
    ) {
        self.characterProvider = characterProvider
    }
}

extension DefaultCharacterService: CharacterService {
    
    func getCharactersDetail(characterId: CLong) -> AnyPublisher<GetCharactersDetailDto, Error> {
        characterProvider.requestPublisher(.getCharactersDetail(characterId: characterId))
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(GetCharactersDetailDto.self)
    }
    
    func getCharactersList(type: Int) -> AnyPublisher<GetCharactersListDto, Error> {
        characterProvider.requestPublisher(.getCharactersList(type: type))
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(GetCharactersListDto.self)
    }
    
    func getCharactersCount() -> AnyPublisher<GetCharactersCountDto, Error> {
        characterProvider.requestPublisher(.getCharactersCount)
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(GetCharactersCountDto.self)
    }
}
