//
//  MemberService.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Combine

protocol MemberService {
    
    // 내 프로필 공개/비공개 토글 API
    func patchProfileVisibility() -> AnyPublisher<Void, Error>
    // 내 정보(이름) 수정하기 API
    func patchProfile(memberNickname: String) -> AnyPublisher<Void, Error>
    // 내 정보 조회하기 API
    func getProfile() -> AnyPublisher<GetProfileDto, Error>
    // 회원탈퇴 하기 API
    func withdraw() -> AnyPublisher<Void, Error>
    
    func getEggPlaying() -> AnyPublisher<GetEggPlayingDto, Error>
    func patchEggPlaying(eggId: Int) -> AnyPublisher<GetEggPlayingDto, Error>
    func getCharacterPlay() -> AnyPublisher<CharacterPlayDto, Error>
    func patchCharacterPlay(characterId: Int) -> AnyPublisher<Void, Error>
    func getRecordedSpot() -> AnyPublisher<RecordedSpotDto, Error>
}
