//
//  GetCharacterPlayUseCase.swift
//  Walkie-iOS
//
//  Created by ahra on 5/6/25.
//

import Combine

protocol GetCharacterPlayUseCase {
    func getCharacterPlay() -> AnyPublisher<CharactersPlayEntity, NetworkError>
}
