//
//  DefaultUpdateStepUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/3/25.
//

import CoreMotion

final class DefaultUpdateStepCacheUseCase: BaseStepUseCase, UpdateStepCacheUseCase {
    
    private let pedometer: CMPedometer
    @UserDefaultsWrapper<Date>(key: "lastUpdateDate") private(set) var lastUpdateDate
    
    init(pedometer: CMPedometer = CMPedometer(), stepStore: StepStore) {
        self.pedometer = pedometer
        super.init(stepStore: stepStore)
    }
    
    func execute() {
        // 권한 및 가용성 확인
        guard CMPedometer.isStepCountingAvailable() else {
            print("[ERROR][UpdateStepUseCase][execute] Step counting not available on this device")
            return
        }
        // 이전 데이터 복구 (캐싱된 데이터 쿼리)
        recoverMissedSteps()
    }
    
    private func recoverMissedSteps() {
        let lastUpdate = lastUpdateDate ?? Date.now
        let now = Date()
        print("[DEBUG][UpdateStepUseCase][recoverMissedSteps] Querying steps from \(lastUpdate) to \(now)")
        
        pedometer.queryPedometerData(from: lastUpdate, to: now) { [weak self] data, error in
            guard let self else {
                print("[ERROR][UpdateStepUseCase][recoverMissedSteps] Self is nil")
                return
            }
            
            if let error = error {
                print("[ERROR][UpdateStepUseCase][recoverMissedSteps] Failed to query pedometer data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("[ERROR][UpdateStepUseCase][recoverMissedSteps] No pedometer data returned")
                return
            }
            
            let steps = data.numberOfSteps.intValue
            print("[DEBUG][UpdateStepUseCase][recoverMissedSteps] Queried \(steps) steps")
            
            // 쿼리된 걸음 수를 현재 걸음 수에 추가
            let newCount = self.stepStore.getStepCountCache() + steps
            self.stepStore.setStepCountCache(newCount)
            print("[DEBUG][UpdateStepUseCase][recoverMissedSteps] "
                  + "Updated step count: \(self.stepStore.getStepCountCache()) + \(steps) = \(newCount)")
            
            // 마지막 업데이트 시간 갱신
            self.lastUpdateDate = now
            print("[DEBUG][UpdateStepUseCase][recoverMissedSteps] Updated lastUpdateDate to \(now)")
        }
    }
}
