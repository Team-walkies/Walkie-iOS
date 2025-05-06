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
                eggType: EggType.from(number: dto.rank),
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
                characterId: dto.characterID,
                characterRank: dto.rank,
                characterType: dto.type,
                characterClass: dto.characterClass
            )}
            .mapToNetworkError()
    }
    
    func getWalkingCharacter() -> AnyPublisher<CharacterEntity, NetworkError> {
        memberService.getCharacterPlay()
            .map { dto in CharacterEntity(
                characterId: dto.characterID,
                type: dto.type == 0 ? .jellyfish : .dino,
                jellyfishType: dto.type == 0 ? CharacterType.mapCharacterType(
                    requestedType: .jellyfish,
                    type: dto.type,
                    rank: dto.rank,
                    characterClass: dto.characterClass
                ) as? JellyfishType : nil,
                dinoType: dto.type == 1 ? CharacterType.mapCharacterType(
                    requestedType: .dino,
                    type: dto.type,
                    rank: dto.rank,
                    characterClass: dto.characterClass
                ) as? DinoType : nil,
                count: dto.count ?? 0,
                isWalking: dto.picked,
                obtainedDetails: nil)
            }
            .mapToNetworkError()
    }
    
    func patchWalkingCharacter(characterId: Int) -> AnyPublisher<Void, NetworkError> {
        memberService.patchCharacterPlay(characterId: characterId)
            .mapToNetworkError()
    }
    
    func getRecordedSpotCount() -> AnyPublisher<Int, NetworkError> {
        memberService.getRecordedSpot()
            .map { dto in
                dto.data
            }
            .mapToNetworkError()
    }
}
