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
    
    func patchEggPlaying(eggId: Int) -> AnyPublisher<Void, Error> {
        memberProvider
            .requestPublisher(
                .patchEggPlaying(eggId: eggId),
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapVoidResponse()
    }
    
    func getCharacterPlay() -> AnyPublisher<CharacterPlayDto, any Error> {
        memberProvider
            .requestPublisher(
                .getCharacterPlay,
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(CharacterPlayDto.self)
    }
    
    func patchCharacterPlay(characterId: Int) -> AnyPublisher<Void, any Error> {
        memberProvider
            .requestPublisher(
                .patchCharacterPlay(characterId: characterId),
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapVoidResponse()

    }
    
    func getRecordedSpot() -> AnyPublisher<RecordedSpotDto, any Error> {
        memberProvider
            .requestPublisher(
                .getRecordedSpot,
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapWithoutDto(RecordedSpotDto.self)
    }
}
