//
//  PatchWalkingCharacterUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/29/25.
//

import Combine

protocol PatchWalkingCharacterUseCase {
    func patchCharacterWalking(characterId: Int) -> AnyPublisher<Void, NetworkError>
}
