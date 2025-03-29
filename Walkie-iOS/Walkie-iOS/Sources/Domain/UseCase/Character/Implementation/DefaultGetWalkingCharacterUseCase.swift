//
//  DefaultGetWalkingCharacterUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/30/25.
//

import Combine

final class DefaultGetWalkingCharacterUseCase {
    
    // MARK: - Dependency
    
    private let memberRepository: MemberRepository
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(memberRepository: MemberRepository) {
        self.memberRepository = memberRepository
    }
}

extension DefaultGetWalkingCharacterUseCase: GetWalkingCharacterUseCase {
    func getCharacterWalking() -> AnyPublisher<CharacterEntity, NetworkError> {
        memberRepository.getWalkingCharacter()
            .mapToNetworkError()
    }
}
