//
//  DefaultUpdateEggStepUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/4/25.
//

import Combine

final class DefaultUpdateEggStepUseCase: BaseEggUseCase, UpdateEggStepUseCase {
    func execute(
        egg: EggEntity,
        step: Int,
        willHatch: Bool = false,
        completion: @escaping () -> Void
    ) {
        eggRepository.patchEggStep(egg: egg, step: step, willHatch: willHatch)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("걸음 수 업데이트 성공!")
                    case .failure(let error):
                        print("걸음 수 업데이트 오류: \(error)")
                    }
                },
                receiveValue: { _ in
                    
                }
            )
            .store(in: &cancellables)
    }
}
