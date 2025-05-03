//
//  DefaultHatchEggUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/1/25.
//

import Foundation
import SwiftUICore

final class DefaultHatchEggUseCase: BaseEggUseCase, HatchEggUseCase {
    
    func hatchEgg() {
        switch UserManager.shared.getCharacterType {
        case .dino:
            let character = UserManager.shared.getDinoType
        case .jellyfish:
            let character = UserManager.shared.getJellyfishType
        }
    }
}
