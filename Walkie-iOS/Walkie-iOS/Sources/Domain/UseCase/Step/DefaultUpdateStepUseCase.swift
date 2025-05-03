//
//  DefaultUpdateStepUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/3/25.
//

import CoreMotion

final class DefaultUpdateStepUseCase: BaseStepUseCase, UpdateStepUseCase {
    
    private let pedometer: CMPedometer
    @UserDefaultsWrapper<Date>(key: "lastUpdateDate") private(set) var lastUpdateDate
    
    init(pedometer: CMPedometer = CMPedometer(), stepStore: StepStore) {
        self.pedometer = pedometer
        super.init(stepStore: stepStore)
        print("[DEBUG][UpdateStepUseCase][init] Initialized with pedometer: \(pedometer), stepStore: \(stepStore)")
    }
    
    func execute() {
        print("[DEBUG][UpdateStepUseCase][execute] Starting step update process")
        
        // 권한 및 가용성 확인
        guard CMPedometer.isStepCountingAvailable() else {
            print("[ERROR][UpdateStepUseCase][execute] Step counting not available on this device")
            return
        }
        print("[DEBUG][UpdateStepUseCase][execute] Step counting is available")
        
        // 이전 데이터 복구 (캐싱된 데이터 쿼리)
        recoverMissedSteps()
        
        // 실시간 걸음 수 업데이트 시작
        startStepUpdates()
        
        print("[DEBUG][UpdateStepUseCase][execute] Step update process completed")
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
            if case .success(let currentCount) = self.stepStore.getStepCount() {
                let newCount = currentCount + steps
                self.stepStore.saveStepCount(newCount)
                print("[DEBUG][UpdateStepUseCase][recoverMissedSteps] Updated step count: \(currentCount) + \(steps) = \(newCount)")
            } else {
                self.stepStore.saveStepCount(steps)
                print("[DEBUG][UpdateStepUseCase][recoverMissedSteps] Set initial step count: \(steps)")
            }
            
            // 마지막 업데이트 시간 갱신
            self.lastUpdateDate = now
            print("[DEBUG][UpdateStepUseCase][recoverMissedSteps] Updated lastUpdateDate to \(now)")
        }
    }
    
    private func startStepUpdates() {
        print("[DEBUG][UpdateStepUseCase][startStepUpdates] Starting real-time step updates")
        
        pedometer.startUpdates(from: Date()) { [weak self] data, error in
            guard let self else {
                print("[ERROR][UpdateStepUseCase][startStepUpdates] Self is nil")
                return
            }
            
            if let error = error {
                print("[ERROR][UpdateStepUseCase][startStepUpdates] Failed to update steps: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("[ERROR][UpdateStepUseCase][startStepUpdates] No step data returned")
                return
            }
            
            let newCount = data.numberOfSteps.intValue
            self.stepStore.saveStepCount(newCount)
            print("[DEBUG][UpdateStepUseCase][startStepUpdates] Saved real-time step count: \(newCount)")
            
            // 마지막 업데이트 시간 갱신
            self.lastUpdateDate = Date()
            print("[DEBUG][UpdateStepUseCase][startStepUpdates] Updated lastUpdateDate to \(self.lastUpdateDate!)")
        }
    }
}
