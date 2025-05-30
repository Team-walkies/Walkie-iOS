//
//  DefaultCheckHatchConditionUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/30/25.
//

import Foundation

final class DefaultCheckHatchConditionUseCase: BaseStepUseCase, CheckHatchConditionUseCase {
    func execute() -> Bool {
        let result = store.getNeedStep() <= store.getNowStep()
        print("🏃 ------ [부화 조건 검사] ------ 🏃")
        print("🏃 \(store.getNowStep()) 걸음 / \(store.getNeedStep()) 걸음 🏃")
        print("🏃 부화 조건 달성 여부 : \(result ? "✅" : "❌") 🏃")
        return result
    }
}
