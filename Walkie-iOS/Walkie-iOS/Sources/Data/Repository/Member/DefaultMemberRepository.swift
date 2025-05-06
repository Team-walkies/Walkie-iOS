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
            .tryMap { dto in
                // 필수 필드 유효성 검사
                guard let eggID = dto.eggID,
                      let type = dto.type,
                      let rank = dto.rank,
                      let characterClass = dto.characterClass,
                      let nowStep = dto.nowStep,
                      let needStep = dto.needStep,
                      let picked = dto.picked else {
                    throw NetworkError.responseDecodingError // 필수 데이터가 없으면 에러 던짐
                }

                // EggEntity 생성
                if type == 0 {
                    let jellyfishType = CharacterType.mapCharacterType(
                        requestedType: .jellyfish,
                        type: type,
                        rank: rank,
                        characterClass: characterClass
                    )
                    return EggEntity(
                        eggId: eggID,
                        eggType: EggType.from(number: rank),
                        nowStep: nowStep,
                        needStep: needStep,
                        isWalking: picked,
                        detail: nil,
                        characterType: .jellyfish,
                        jellyFishType: jellyfishType as? JellyfishType,
                        dinoType: nil
                    )
                } else {
                    let dinoType = CharacterType.mapCharacterType(
                        requestedType: .dino,
                        type: type,
                        rank: rank,
                        characterClass: characterClass
                    )
                    return EggEntity(
                        eggId: eggID,
                        eggType: EggType.from(number: rank),
                        nowStep: nowStep,
                        needStep: needStep,
                        isWalking: picked,
                        detail: nil,
                        characterType: .dino,
                        jellyFishType: nil,
                        dinoType: dinoType as? DinoType
                    )
                }
            }
            .mapError { error in
                // 기존 에러를 NetworkError로 변환
                if error is NetworkError {
                    return error as? NetworkError ?? .notFoundError
                }
                return NetworkError.responseDecodingError
            }
            .eraseToAnyPublisher()
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
    
    func patchProfileVisibility() -> AnyPublisher<Void, NetworkError> {
        memberService.patchProfileVisibility()
            .mapToNetworkError()
    }
    
    func patchProfile(memberNickname: String) -> AnyPublisher<Void, NetworkError> {
        memberService.patchProfile(memberNickname: memberNickname)
            .mapToNetworkError()
    }
    
    func getProfile() -> AnyPublisher<UserEntity, NetworkError> {
        memberService.getProfile()
            .map { dto in
                UserEntity(
                    nickname: dto.nickname,
                    exploredSpotCount: dto.exploredSpot ?? 0,
                    recordedSpotCount: dto.recordedSpot ?? 0,
                    isPublic: dto.isPublic,
                    memberTier: dto.memberTier
                )
            }.mapToNetworkError()
    }
    
    func withdraw() -> AnyPublisher<Void, NetworkError> {
        memberService.withdraw()
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
