//
//  HatchEggUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/30/25.
//

import Foundation
import Combine

protocol HatchEggUseCase {
    func execute(egg: EggEntity)
}
