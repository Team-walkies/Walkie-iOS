//
//  DefaultHomeRepository.swift
//  Walkie-iOS
//
//  Created by ahra on 3/12/25.
//

import Combine

final class DefaultHomeRepository {
    
    // MARK: - Dependency
    
    private let homeService: HomeService
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(homeService: HomeService) {
        self.homeService = homeService
    }
}

extension DefaultHomeRepository: HomeRepository {
    
    func getEggCount() -> AnyPublisher<EggCountDto, Error> {
        homeService.getEggCount()
            .eraseToAnyPublisher()
    }
}
