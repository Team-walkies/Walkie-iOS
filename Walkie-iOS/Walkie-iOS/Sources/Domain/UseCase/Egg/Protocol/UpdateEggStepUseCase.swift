//
//  UpdateEggStepUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/4/25.
//

import Combine

protocol UpdateEggStepUseCase {
    func execute(
        egg: EggEntity,
        step: Int,
        willHatch: Bool
    )
}
