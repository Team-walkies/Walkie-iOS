//
//  DefaultCheckStepUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/3/25.
//

import UIKit

final class DefaultCheckStepUseCase: BaseStepUseCase, CheckStepUseCase {
    func execute() {
        switch self.stepStore.getStepCount() {
        case .success(let stepCount):
            switch self.stepStore.getStepCountGoal() {
            case .success(let stepCountGoal):
                print("현재 걸음 수 \(stepCount), 목표 걸음 수 \(stepCountGoal)")
                UserManager.shared.updateHatchState(stepCount >= stepCountGoal)
                self.stepStore.resetStepCount()
            case .failure:
                print("💀💀💀 같이 걷고 있는 알이 없음 💀💀💀")
            }
        case .failure:
            print("💀💀💀 걸음 수 불러오기 실패 💀💀💀")
        }
    }
}
