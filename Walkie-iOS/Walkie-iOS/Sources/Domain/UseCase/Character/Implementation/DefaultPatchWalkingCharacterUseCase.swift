//
//  DefaultPatchWalkingCharacterUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/30/25.
//

import Combine

final class DefaultPatchWalkingCharacterUseCase: BaseMemberUseCase, PatchWalkingCharacterUseCase {
    func patchCharacterWalking(characterId: Int) -> AnyPublisher<Void, NetworkError> {
        memberRepository.patchWalkingCharacter(characterId: characterId)
            .mapToNetworkError()
    }
}
