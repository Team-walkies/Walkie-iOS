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
                guard
                    let eggID = dto.eggID,
                    let type = dto.characterType,
                    let eggRank = dto.rank,
                    let characterRank = dto.characterRank,
                    let characterClass = dto.characterClass,
                    let nowStep = dto.nowStep,
                    let needStep = dto.needStep,
                    let picked = dto.picked else {
                    throw NetworkError.responseDecodingError // 필수 데이터가 없으면 에러 던짐
                }

                // EggEntity 생성
                if type == 0 {
                    let jellyfishType = try JellyfishType.mapCharacterType(
                        rank: characterRank,
                        characterClass: characterClass
                    )
                    return EggEntity(
                        eggId: eggID,
                        eggType: EggType.from(number: eggRank),
                        nowStep: nowStep,
                        needStep: needStep,
                        isWalking: picked,
                        detail: nil,
                        characterType: .jellyfish,
                        jellyFishType: jellyfishType,
                        dinoType: nil
                    )
                } else {
                    let dinoType = try DinoType.mapCharacterType(rank: characterRank, characterClass: characterClass)
                    return EggEntity(
                        eggId: eggID,
                        eggType: EggType.from(number: eggRank),
                        nowStep: nowStep,
                        needStep: needStep,
                        isWalking: picked,
                        detail: nil,
                        characterType: .dino,
                        jellyFishType: nil,
                        dinoType: dinoType
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
    
    func patchEggPlaying(eggId: Int) -> AnyPublisher<EggEntity, NetworkError> {
        memberService.patchEggPlaying(eggId: eggId)
            .tryMap { dto in
                guard
                    let eggID = dto.eggID,
                    let type = dto.characterType,
                    let eggRank = dto.rank,
                    let characterClass = dto.characterClass,
                    let characterRank = dto.characterRank,
                    let nowStep = dto.nowStep,
                    let needStep = dto.needStep,
                    let picked = dto.picked
                else {
                    throw NetworkError.responseDecodingError // 필수 데이터가 없으면 에러 던짐
                }
                
                return EggEntity(
                    eggId: eggID,
                    eggType: EggType.from(number: eggRank),
                    nowStep: nowStep,
                    needStep: needStep,
                    isWalking: picked,
                    detail: EggDetailEntity(
                        obtainedPosition: dto.obtainedPosition ?? "",
                        obtainedDate: dto.obtainedDate ?? ""
                    ),
                    characterType: type == 0 ? .jellyfish : .dino,
                    jellyFishType: try JellyfishType.mapCharacterType(
                        rank: characterRank,
                        characterClass: characterClass
                    ),
                    dinoType: try DinoType.mapCharacterType(
                        rank: characterRank,
                        characterClass: characterClass
                    )
                )
            }
            .mapToNetworkError()
    }
    
    // 중복
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
    
    // 중복
    func getWalkingCharacter() -> AnyPublisher<CharacterEntity, NetworkError> {
        memberService.getCharacterPlay()
            .map { dto in CharacterEntity(
                characterId: dto.characterID,
                type: dto.type == 0 ? .jellyfish : .dino,
                jellyfishType: try? JellyfishType.mapCharacterType(rank: dto.rank, characterClass: dto.characterClass),
                dinoType: try? DinoType.mapCharacterType(rank: dto.rank, characterClass: dto.characterClass),
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
