//
//  DefaultUpdateStepForegroundUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/30/25.
//

import CoreMotion
import Combine

final class DefaultUpdateStepForegroundUseCase: BaseStepUseCase, UpdateStepForegroundUseCase {
    
    private var subject = PassthroughSubject<Int, Error>() // 퍼블리셔 선언
    
    func start() -> AnyPublisher<Int, Error> {
        // 시작 걸음 수
        let startStepCount = store.getNowStep()
        // 걸음 수 측정 권한
        guard CMPedometer.isStepCountingAvailable() else {
            subject.send(completion: .failure(StepError.stepCountingUnavailable))
            return subject.eraseToAnyPublisher()
        }
        guard CMPedometer.authorizationStatus() == .authorized else {
            subject.send(completion: .failure(StepError.authorizationDenied))
            return subject.eraseToAnyPublisher()
        }
        let startTime = store.getLastUpdateTime()
        var lastQueriedStepCount: Int = 0
        dump("🏃포그라운드 걸음 수 업데이트 시작 : \(startTime)🏃")
        
        // 가장 최근 업데이트 시각부터 쿼리 시작
        pedometer.startUpdates(from: startTime) { [weak self] data, error in
            guard let self = self else { return }
            
            if let error = error {
                self.subject.send(completion: .failure(error))
                return
            }
            
            guard let data = data else { return } // 오류
            
            /// 쿼리된 걸음 수
            let queriedSteps = data.numberOfSteps.intValue
            /// 새로운 데이터가 아닐 경우 무시
            if lastQueriedStepCount == queriedSteps { return }
            /// 마지막 쿼리된 데이터 업데이트
            lastQueriedStepCount = queriedSteps
            
            /// 로깅
            print("🏃 ------ [포그라운드 걸음 수 쿼리 : \(Date())] ------ 🏃")
            print("🏃 포그라운드 걸음 수 쿼리 : 처음 시작 시점으로부터 + \(queriedSteps) 걸음 증가 🏃")
            print("🏃 업데이트 이전 걸음 수 : \(store.getNowStep()) 🏃")
            
            /// 쿼리된 걸음 수를 현재 걸음 수에 추가합니다
            store.setNowStep(startStepCount + queriedSteps)
            
            /// 로깅
            print("🏃 포그라운드 업데이트 완료 - \(store.getNowStep()) 걸음 / \(store.getNeedStep()) 걸음 🏃")
            
            /// 마지막 업데이트 시각을 업데이트합니다
            store.setLastUpdateTime(Date())
            self.subject.send(data.numberOfSteps.intValue)
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    // 종료
    func stop() {
        pedometer.stopUpdates()
        subject.send(completion: .finished)
        subject = PassthroughSubject<Int, Error>() // 새로운 Subject로 교체
        dump("🏃포그라운드 걸음 수 업데이트 종료 : \(Date())🏃")
    }
}

enum StepError: Error {
    case stepCountingUnavailable
    case authorizationDenied
}
