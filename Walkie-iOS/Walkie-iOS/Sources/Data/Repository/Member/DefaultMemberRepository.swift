//
//  DefaultMemberRepository.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Combine

final class DefaultMemberRepository {
    
    // MARK: - Dependency
    
    private let memberService: MemberService
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(memberService: MemberService) {
        self.memberService = memberService
    }
}

extension DefaultMemberRepository: MemberRepository {
    
    func getEggPlaying() -> AnyPublisher<EggEntity, NetworkError> {
        memberService.getEggPlaying()
            .map { dto in EggEntity(
                eggId: dto.eggID,
                eggType: EggLiterals.from(number: dto.rank),
                nowStep: dto.nowStep,
                needStep: dto.needStep,
                isWalking: true,
                detail: nil)
            }.mapToNetworkError()
    }
    
    func patchEggPlaying(eggId: Int) -> AnyPublisher<Void, NetworkError> {
        memberService.patchEggPlaying(eggId: eggId)
            .map { _ in return }
            .mapToNetworkError()
    }
    
    func getCharacterPlay() -> AnyPublisher<CharactersPlayEntity, NetworkError> {
        memberService.getCharacterPlay()
            .map { dto in CharactersPlayEntity(
                characterID: dto.characterID,
                characterType: dto.type,
                characterClass: dto.characterClass
            )}
            .mapToNetworkError()
    }
}
