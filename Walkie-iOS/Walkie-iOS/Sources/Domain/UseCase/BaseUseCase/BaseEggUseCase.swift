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
    
    // MARK: - Properties
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(eggRepository: EggRepository) {
        self.eggRepository = eggRepository
    }
}
