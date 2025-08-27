//
//  DefaultMemberService.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Moya

import Combine
import CombineMoya

final class DefaultMemberService {
    
    private let memberProvider: MoyaProvider<MemberTarget>
    private let reissueService: DefaultReissueService
    
    init(
        memberProvider: MoyaProvider<MemberTarget> = MoyaProvider<MemberTarget>(plugins: [NetworkLoggerPlugin()]),
        reissueService: DefaultReissueService
    ) {
        self.memberProvider = memberProvider
        self.reissueService = reissueService
    }
}

extension DefaultMemberService: MemberService {
    
    func getEggPlaying() -> AnyPublisher<GetEggPlayingDto, Error> {
        memberProvider
            .requestPublisher(
                .getEggPlaying,
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(GetEggPlayingDto.self)
    }
    
    func patchEggPlaying(eggId: Int) -> AnyPublisher<GetEggPlayingDto, Error> {
        memberProvider
            .requestPublisher(
                .patchEggPlaying(eggId: eggId),
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(GetEggPlayingDto.self)
    }
    
    func getCharacterPlay() -> AnyPublisher<CharacterPlayDto, Error> {
        memberProvider
            .requestPublisher(
                .getCharacterPlay,
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(CharacterPlayDto.self)
    }
    
    func patchCharacterPlay(characterId: Int) -> AnyPublisher<Void, Error> {
        memberProvider
            .requestPublisher(
                .patchCharacterPlay(characterId: characterId),
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapVoidResponse()

    }
    
    func getRecordedSpot() -> AnyPublisher<RecordedSpotDto, Error> {
        memberProvider
            .requestPublisher(
                .getRecordedSpot,
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapWithoutDto(RecordedSpotDto.self)
    }
    
    func patchProfileVisibility() -> AnyPublisher<Void, Error> {
        memberProvider
            .requestPublisher(
                .patchUserProfileVisibility,
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapVoidResponse()
    }
    
    func patchProfile(memberNickname: String) -> AnyPublisher<Void, Error> {
        memberProvider
            .requestPublisher(
                .patchUserProfile(
                    memberNickname: memberNickname
                ),
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapVoidResponse()
    }
    
    func getProfile() -> AnyPublisher<GetProfileDto, Error> {
        memberProvider
            .requestPublisher(
                .getUserProfile,
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(GetProfileDto.self)
    }
    
    func withdraw() -> AnyPublisher<Void, Error> {
        memberProvider
            .requestPublisher(
                .withdraw,
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapVoidResponse()
    }
    
}
