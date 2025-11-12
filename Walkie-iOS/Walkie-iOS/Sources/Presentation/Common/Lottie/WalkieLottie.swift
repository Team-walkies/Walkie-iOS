//
//  WalkieLottie.swift
//  Walkie-iOS
//
//  Created by 고아라 on 8/4/25.
//

enum WalkieLottie {
    case confetti
    case eggBlue
    case eggGreen
    case eggPurple
    case eggYellow
    case healthcareInfo
    case healthkit
    case healthkit26
    case giveEggConfetti
    case eggButton
    
    var filename: String {
        switch self {
        case .confetti:
            return "walkie_Confetti"
        case .eggBlue:
            return "walkie_EggBlue"
        case .eggGreen:
            return "walkie_EggGreen"
        case .eggPurple:
            return "walkie_EggPurple"
        case .eggYellow:
            return "walkie_EggYellow"
        case .healthcareInfo:
            return "walkie_HealthcareInfo"
        case .healthkit:
            return "walkie_Healthkit"
        case .healthkit26:
            return "walkie_Healthkit_ios26"
        case .giveEggConfetti:
            return "walkie_ConfettiColored"
        case .eggButton:
            return "walkie_EggButton"
        }
    }
}
