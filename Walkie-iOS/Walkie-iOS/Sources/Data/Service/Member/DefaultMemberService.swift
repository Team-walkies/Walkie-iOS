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
    
    init(memberProvider: MoyaProvider<MemberTarget> = MoyaProvider<MemberTarget>(plugins: [NetworkLoggerPlugin()])) {
        self.memberProvider = memberProvider
    }
}

extension DefaultMemberService: MemberService {
    
    func getEggPlaying() -> AnyPublisher<GetEggPlayingDto, Error> {
        memberProvider.requestPublisher(.getEggPlaying)
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(GetEggPlayingDto.self)
    }
    
    func patchEggPlaying(eggId: Int) -> AnyPublisher<Int?, Error> {
        memberProvider.requestPublisher(.patchEggPlaying(eggId: eggId))
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(Int?.self)
    }
    
    func getCharacterPlay() -> AnyPublisher<CharacterPlayDto, any Error> {
        memberProvider.requestPublisher(.getCharacterPlay)
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(CharacterPlayDto.self)
    }
}
