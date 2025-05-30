//
//  BaseStepUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/3/25.
//

import Combine
import CoreMotion

class BaseStepUseCase {
    
    // MARK: - Dependency
    
    let store: StepStatusStore
    let pedometer: CMPedometer
    
    // MARK: - Properties
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(store: StepStatusStore) {
        self.store = store
        self.pedometer = CMPedometer()
    }
}
