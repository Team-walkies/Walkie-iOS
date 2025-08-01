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
    private let reissueService: DefaultReissueService
    
    init(
        characterProvider: MoyaProvider<CharacterTarget> = MoyaProvider<CharacterTarget>(
        plugins: [NetworkLoggerPlugin()]),
        reissueService: DefaultReissueService
    ) {
        self.characterProvider = characterProvider
        self.reissueService = reissueService
    }
}

extension DefaultCharacterService: CharacterService {
    
    func getCharactersDetail(characterId: CLong) -> AnyPublisher<GetCharactersDetailDto, Error> {
        characterProvider
            .requestPublisher(
                .getCharactersDetail(characterId: characterId),
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(GetCharactersDetailDto.self)
    }
    
    func getCharactersList(type: Int) -> AnyPublisher<GetCharactersListDto, Error> {
        characterProvider
            .requestPublisher(
                .getCharactersList(type: type),
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(GetCharactersListDto.self)
    }
    
    func getCharactersCount() -> AnyPublisher<GetCharactersCountDto, Error> {
        characterProvider
            .requestPublisher(
                .getCharactersCount,
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(GetCharactersCountDto.self)
    }
}
