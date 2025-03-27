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
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(eggRepository: EggRepository) {
        self.eggRepository = eggRepository
    }
}

extension DefaultHomeUseCase: HomeUseCase {
    
    func getEggCount() -> AnyPublisher<EggsCountEntity, NetworkError> {
        eggRepository.getEggsCount()
            .mapToNetworkError()
    }
}
