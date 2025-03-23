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
    
    func getEggPlaying() -> AnyPublisher<GetEggPlayingDto, Error> {
        memberService.getEggPlaying()
            .eraseToAnyPublisher()
    }
    
    func patchEggPlaying(eggId: Int) -> AnyPublisher<Int?, Error> {
        memberService.patchEggPlaying(eggId: eggId)
            .eraseToAnyPublisher()
    }
}
