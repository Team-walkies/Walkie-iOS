//
//  DefaultUpdateStepBackgroundUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/30/25.
//

import Foundation

final class DefaultUpdateStepBackgroundUseCase: BaseStepUseCase, UpdateStepBackgroundUseCase {
    
    func execute() {
        // 백그라운드에서 걸음 수 쿼리로 업데이트 시 수행하는 로직
        let now = Date()
        pedometer.queryPedometerData(from: store.getLastUpdateTime(), to: now) { [weak self] data, error in
            
            /// 각종 에러 처리
            guard let self else { return }
            if let error = error { print("🏃 걸음 수 조회 에러 : \(error.localizedDescription) 🏃") }
            guard let data = data else {
                print("🏃 걸음 수 조회 에러 : 데이터 없음 🏃")
                return
            }
            
            /// 쿼리된 걸음 수
            let queriedSteps = data.numberOfSteps.intValue
            /// 로깅
            print("🏃 백그라운드 걸음 수 쿼리 시각 : \(now) 🏃")
            print("🏃 백그라운드 걸음 수 쿼리 : \(queriedSteps) 🏃")
            print("🏃 업데이트 이전 걸음 수 : \(store.getNowStep()) 🏃")
            
            /// 쿼리된 걸음 수를 현재 걸음 수에 추가합니다
            store.setNowStep(store.getNowStep() + queriedSteps)
            /// 로깅
            print("🏃 백그라운드 걸음 수 업데이트 완료! 🏃")
            print("🏃 현재 걸음수 : \(store.getNowStep()) 🏃")
            print("🏃 목표 걸음수 : \(store.getNeedStep()) 🏃")
            
            /// 마지막 업데이트 시각을 업데이트합니다
            store.setLastUpdateTime(now)
        }
    }
}
