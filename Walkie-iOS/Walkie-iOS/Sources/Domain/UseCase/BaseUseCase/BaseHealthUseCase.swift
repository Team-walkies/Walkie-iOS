//
//  BaseHealthUseCase.swift
//  Walkie-iOS
//
//  Created by 고아라 on 8/18/25.
//

import Combine

class BaseHealthUseCase {
    
    // MARK: - Dependency
    
    let healthRepository: HealthRepository
    
    // MARK: - Properties
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(healthRepository: HealthRepository) {
        self.healthRepository = healthRepository
    }
}
