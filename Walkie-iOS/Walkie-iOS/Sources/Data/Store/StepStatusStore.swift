//
//  StepStatusStore.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/30/25.
//

import Foundation

protocol StepStatusStore {
    // MARK: - Getter
    func getNowStep() -> Int // 현재 걸음 수를 리턴합니다
    func getNeedStep() -> Int // 필요한 걸음 수를 리턴합니다
    func getLastUpdateTime() -> Date // 마지막으로 걸음수를 업데이트한 시각을 리턴합니다
    
    // MARK: - Setter
    func setNowStep(_ nowStep: Int) // 현재 걸음수를 업데이트 합니다
    func setNeedStep(_ needStep: Int) // 알이 바뀐 경우 목표 걸음수를 교체합니다
    func setLastUpdateTime(_ time: Date) // 걸음수 업데이트 시각을 업데이트합니다
    
    // MARK: - Reset
    func resetStepStatus() // 알 미선택 상태로 되돌립니다
}

final class DefaultStepStatusStore: StepStatusStore {
    
    // MARK: - Properties
    @UserDefaultsWrapper<Int>(key: StepStatusStoreKey.needStep.rawValue) private(set) var needStep
    @UserDefaultsWrapper<Int>(key: StepStatusStoreKey.nowStep.rawValue) private(set) var nowStep
    @UserDefaultsWrapper<Date>(key: StepStatusStoreKey.lastUpdateTime.rawValue) private(set) var lastUpdateTime
    
    // MARK: - Implement
    func getNowStep() -> Int {
        return nowStep ?? 0
    }
    
    func getNeedStep() -> Int {
        return needStep ?? .max
    }
    
    func getLastUpdateTime() -> Date {
        return lastUpdateTime ?? Date()
    }
    
    func setNowStep(_ nowStep: Int) {
        self.nowStep = nowStep
    }
    
    func setNeedStep(_ needStep: Int) {
        self.needStep = needStep
    }
    
    func setLastUpdateTime(_ time: Date) {
        self.lastUpdateTime = time
    }
    
    func resetStepStatus() {
        setNowStep(0)
        setNeedStep(.max)
        lastUpdateTime = Date()
    }
}
