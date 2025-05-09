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
            <= UserManager.shared.getStepCount
            + stepStore.getStepCountCache() {
            NotificationManager.shared.scheduleNotification(
                title: "알이 부화하려고 해요!",
                body: "어서 가서 깨워주세요"
            )
        }
    }
}
