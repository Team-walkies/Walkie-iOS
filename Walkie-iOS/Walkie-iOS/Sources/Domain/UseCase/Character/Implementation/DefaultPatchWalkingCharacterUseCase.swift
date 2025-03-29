//
//  DefaultPatchWalkingCharacterUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/30/25.
//

import Combine

final class DefaultPatchWalkingCharacterUseCase {
    
    // MARK: - Dependency
    
    private let memberRepository: MemberRepository
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(memberRepository: MemberRepository) {
        self.memberRepository = memberRepository
    }
}

extension DefaultPatchWalkingCharacterUseCase: PatchWalkingCharacterUseCase {
    func patchCharacterWalking(characterId: Int) -> AnyPublisher<Void, NetworkError> {
        memberRepository.patchWalkingCharacter(characterId: characterId)
            .mapToNetworkError()
    }
}
