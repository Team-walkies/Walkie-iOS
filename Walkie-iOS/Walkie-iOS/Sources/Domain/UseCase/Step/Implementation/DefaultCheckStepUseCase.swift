//
//  DefaultCheckStepUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/3/25.
//

import UIKit

final class DefaultCheckStepUseCase: BaseStepUseCase, CheckStepUseCase {
    func execute() {
        if UserManager.shared.getStepCountGoal
            >= UserManager.shared.getStepCount
            + stepStore.getStepCountCache() {
            // 푸시 알림 전송
        }
    }
}
