//
//  BaseUserUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import Combine

class BaseUserUseCase {
    
    // MARK: - Dependency
    
    let authRepository: AuthRepository
    let memberRepository: MemberRepository
    let stepStatusStore: StepStatusStore
    
    // MARK: - Properties
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(authRepository: AuthRepository, memberRepository: MemberRepository, stepStatusStore: StepStatusStore) {
        self.authRepository = authRepository
        self.memberRepository = memberRepository
        self.stepStatusStore = stepStatusStore
    }
}
