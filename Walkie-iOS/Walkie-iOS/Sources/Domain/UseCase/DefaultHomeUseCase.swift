//
//  DefaultHomeUseCase.swift
//  Walkie-iOS
//
//  Created by ahra on 3/12/25.
//

import Combine

final class DefaultHomeUseCase {
    
    // MARK: - Dependency
    
    private let homeRepository: HomeRepository
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(homeRepository: HomeRepository) {
        self.homeRepository = homeRepository
    }
}

extension DefaultHomeUseCase: HomeUseCase {
    
    func getEggCount() -> AnyPublisher<EggsCountEntity, NetworkError> {
        homeRepository.getEggCount()
            .map { dto in EggsCountEntity(eggsCount: dto.eggCount) }
            .mapToNetworkError()
    }
}
