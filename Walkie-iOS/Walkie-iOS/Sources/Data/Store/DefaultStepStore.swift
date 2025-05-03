//
//  DefaultStepStore.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/3/25.
//

import Foundation

final class DefaultStepStore {
    @UserDefaultsWrapper<Int>(key: "stepCount") private(set) var stepCount
}

extension DefaultStepStore: StepStore {
    func resetStepCount() {
        self.stepCount = 0
    }
    
    func getStepCount() -> Result<Int, StepStoreError> {
        guard let data = self.stepCount else {
            return .failure(.noDataFound)
        }
        return .success(data)
    }
    
    func saveStepCount(_ count: Int) {
        self.stepCount = count
    }
    
    func getStepCountGoal() -> Result<Int, StepStoreError> {
        guard let data = UserManager.shared.eggType?.walkCount else {
            return .failure(.noDataFound)
        }
        return .success(data)
    }
}
