//
//  DefaultEggUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Combine

final class DefaultEggUseCase {
    
    // MARK: - Dependency
    
    private let eggRepository: EggRepository
    private let memberRepository: MemberRepository
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(eggRepository: EggRepository, memberRepository: MemberRepository) {
        self.eggRepository = eggRepository
        self.memberRepository = memberRepository
    }
}

extension DefaultEggUseCase: EggUseCase {
    
    func patchEggPlaying(eggId: Int) -> AnyPublisher<Void, NetworkError> {
        memberRepository.patchEggPlaying(eggId: eggId)
            .mapToNetworkError()
    }
    
    func getEggsList() -> AnyPublisher<[EggEntity], NetworkError> {
        eggRepository.getEggsList()
            .mapToNetworkError()
    }
    
    func getEggDetail(eggId: Int) -> AnyPublisher<EggDetailEntity, NetworkError> {
        eggRepository.getEggDetail(eggId: eggId)
            .mapToNetworkError()
    }
    
    func patchEggStep(requestBody: PatchEggStepRequestDto) -> AnyPublisher<Void, NetworkError> {
        eggRepository.patchEggStep(requestBody: requestBody)
            .mapToNetworkError()
    }
}
