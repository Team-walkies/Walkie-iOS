//
//  BaseEggUseCase.swift
//  Walkie-iOS
//
//  Created by ahra on 4/2/25.
//

import Combine

class BaseEggUseCase {
    
    // MARK: - Dependency
    
    let eggRepository: EggRepository
    let stepStatusStore: StepStatusStore
    
    // MARK: - Properties
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(eggRepository: EggRepository, stepStatusStore: StepStatusStore) {
        self.eggRepository = eggRepository
        self.stepStatusStore = stepStatusStore
    }
}
