//
//  MemberRepository.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Combine

protocol MemberRepository {
    // 같이 걷는 알 조회 API
    func getEggPlaying() -> AnyPublisher<EggEntity, NetworkError>
    // 같이 걷는 알 변경 API
    func patchEggPlaying(eggId: Int) -> AnyPublisher<EggEntity, NetworkError>
    // 같이 걷는 캐릭터 조회 API
    func getCharacterPlay() -> AnyPublisher<CharactersPlayEntity, NetworkError>
    // 같이 걷는 캐릭터 조회 API(중복)
    func getWalkingCharacter() -> AnyPublisher<CharacterEntity, NetworkError>
    // 같이 걷는 캐릭터 변경 API
    func patchWalkingCharacter(characterId: Int) -> AnyPublisher<Void, NetworkError>
    // 내 프로필 공개/비공개 토글 API
    func patchProfileVisibility() -> AnyPublisher<Void, NetworkError>
    // 내 정보 수정하기 API
    func patchProfile(memberNickname: String) -> AnyPublisher<Void, NetworkError>
    // 내 정보 조회하기 API
    func getProfile() -> AnyPublisher<UserEntity, NetworkError>
    // 회원탈퇴 하기 API
    func withdraw() -> AnyPublisher<Void, NetworkError>
    // 기록한 스팟 개수 조회하기 API
    func getRecordedSpotCount() -> AnyPublisher<Int, NetworkError>
}
