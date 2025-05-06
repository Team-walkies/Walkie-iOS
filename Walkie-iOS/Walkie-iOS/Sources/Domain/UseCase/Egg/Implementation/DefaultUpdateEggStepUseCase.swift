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
        willHatch: Bool = false
    ) {
        if let location = LocationManager.shared.getCurrentLocation(), willHatch {
            _ = eggRepository.patchEggStep(
                requestBody: .init(
                    eggId: egg.eggId,
                    nowStep: step,
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
            )
        } else {
            _ = eggRepository.patchEggStep(
                requestBody: .init(
                    eggId: egg.eggId,
                    nowStep: step,
                    latitude: nil,
                    longitude: nil
                )
            )
        }
    }
}
