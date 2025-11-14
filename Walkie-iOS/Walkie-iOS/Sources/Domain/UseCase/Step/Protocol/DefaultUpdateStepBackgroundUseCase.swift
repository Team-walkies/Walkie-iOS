//
//  DefaultUpdateStepBackgroundUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/30/25.
//

import Foundation

final class DefaultUpdateStepBackgroundUseCase: BaseStepUseCase, UpdateStepBackgroundUseCase {
    
    func execute(completion: @escaping () -> Void) {
        let now = Date()
        pedometer.queryPedometerData(from: store.getLastUpdateTime(), to: now) { [weak self] data, error in
            
            /// 각종 에러 처리
            guard let self else {
                completion()
                return
            }
            if let error = error { print("🏃 걸음 수 조회 에러 : \(error.localizedDescription) 🏃") }
            guard let data = data else {
                completion()
                return
            }
            
            /// 걸음 수 쿼리 및 업데이트
            let queriedSteps = data.numberOfSteps.intValue
            store.setNowStep(store.getNowStep() + queriedSteps)
            store.setLastUpdateTime(now)
            completion()
        }
    }
}
