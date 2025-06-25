//
//  DefaultHatchEggUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/30/25.
//

import Foundation

final class DefaultHatchEggUseCase: BaseEggUseCase, HatchEggUseCase {
    func execute(egg: EggEntity) {
        eggRepository.patchEggStep(egg: egg, step: egg.needStep, willHatch: true)
            .walkieSink(
                with: self,
                receiveValue: { _, _ in
                    print("🥚 알 부화 완료 🥚")
                    self.stepStatusStore.resetStepStatus() // 걸음 수 데이터 모두 초기화
                    NotificationManager.shared.notified = false
                },
                receiveFailure: { _, error in
                    print("🥚 알 부화 실패 : \(String(describing: error?.localizedDescription)) 🥚")
                }
            )
            .store(in: &cancellables)
    }
}
