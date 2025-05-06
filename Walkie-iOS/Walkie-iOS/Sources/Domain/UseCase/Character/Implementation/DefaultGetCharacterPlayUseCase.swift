//
//  DefaultGetCharacterPlayUseCase.swift
//  Walkie-iOS
//
//  Created by ahra on 5/6/25.
//

import Combine

final class DefaultGetCharacterPlayUseCase: BaseMemberUseCase, GetCharacterPlayUseCase {
    func getCharacterPlay() -> AnyPublisher<CharactersPlayEntity, NetworkError> {
        memberRepository.getCharacterPlay()
            .mapToNetworkError()
    }
}
