//
//  BaseStepUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/3/25.
//

import Combine

class BaseStepUseCase {
    
    // MARK: - Dependency
    
    let stepStore: StepStore
    
    // MARK: - Properties
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(stepStore: StepStore) {
        self.stepStore = stepStore
    }
}
