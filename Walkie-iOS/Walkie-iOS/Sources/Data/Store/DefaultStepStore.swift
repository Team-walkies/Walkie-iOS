//
//  DefaultStepStore.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/3/25.
//

import Foundation

final class DefaultStepStore {
    @UserDefaultsWrapper<Int>(key: "stepCountCache") private(set) var stepCountCache
}

extension DefaultStepStore: StepStore {
    
    func resetStepCountCache() {
        self.stepCountCache = 0
    }
    
    func getStepCountCache() -> Int {
        self.stepCountCache ?? 0
    }
    
    func setStepCountCache(_ count: Int) {
        self.stepCountCache = count
    }
}
