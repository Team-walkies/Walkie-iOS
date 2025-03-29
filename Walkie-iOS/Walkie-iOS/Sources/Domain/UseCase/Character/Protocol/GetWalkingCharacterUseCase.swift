//
//  GetWalkingCharacterUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/30/25.
//

import Combine

protocol GetWalkingCharacterUseCase {
    func getCharacterWalking() -> AnyPublisher<CharacterEntity, NetworkError>
}
