//
//  DefaultHomeUseCase.swift
//  Walkie-iOS
//
//  Created by ahra on 3/12/25.
//

import Combine

final class DefaultHomeUseCase {
    
    // MARK: - Dependency
    
    private let eggRepository: EggRepository
    private let memberRepository: MemberRepository
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(
        eggRepository: EggRepository,
        memberRepository: MemberRepository
    ) {
        self.eggRepository = eggRepository
        self.memberRepository = memberRepository
    }
}

extension DefaultHomeUseCase: HomeUseCase {
    
    // egg
    
    func getEggCount() -> AnyPublisher<EggsCountEntity, NetworkError> {
        eggRepository.getEggsCount()
            .mapToNetworkError()
    }
    
    // member
    
    func getEggPlay() -> AnyPublisher<EggInfoEntity, NetworkError> {
        memberRepository.getEggPlayId()
            .mapToNetworkError()
    }
    
    func getCharacterPlay() -> AnyPublisher<CharactersPlayEntity, NetworkError> {
        memberRepository.getCharacterPlay()
            .mapToNetworkError()
    }
}
