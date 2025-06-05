//
//  BaseMemberUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/30/25.
//

import Combine

class BaseMemberUseCase {
    
    // MARK: - Dependency
    
    let memberRepository: MemberRepository
    let stepStatusStore: StepStatusStore
    
    // MARK: - Properties
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(memberRepository: MemberRepository, stepStatusStore: StepStatusStore) {
        self.memberRepository = memberRepository
        self.stepStatusStore = stepStatusStore
    }
}
