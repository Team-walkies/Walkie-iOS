//
//  DefaultGetTodayStepUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 10/5/25.
//

import Combine
import CoreMotion

final class DefaultGetTodayStepUseCase: BaseStepUseCase, GetTodayStepUseCase {
    func execute(completion: @escaping (Result<Int, Error>) -> Void) {
        guard CMPedometer.isStepCountingAvailable() else {
            completion(.failure(StepError.stepCountingUnavailable))
            return
        }
        
        switch CMPedometer.authorizationStatus() {
        case .authorized:
            break
        case .notDetermined, .denied, .restricted:
            completion(.failure(StepError.authorizationDenied))
            return
        @unknown default:
            completion(.failure(StepError.authorizationDenied))
            return
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        pedometer.queryPedometerData(from: startOfDay, to: now) { data, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let steps = data?.numberOfSteps.intValue ?? 0
            completion(.success(steps))
        }
    }
}
