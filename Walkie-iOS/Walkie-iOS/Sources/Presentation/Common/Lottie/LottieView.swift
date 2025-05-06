//
//  LottieView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/9/25.
//

import SwiftUI

import Lottie

enum WalkieLottie {
    case confetti
    case eggBlue
    case eggGreen
    case eggPurple
    case eggYellow
    
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
        }
    }
}

struct WalkieLottieView: View {
    let lottie: WalkieLottie
    let isPlaying: Bool

    var body: some View {
        LottieView(animation: .named(lottie.filename))
            .playbackMode(isPlaying ? .playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce)) : .paused)
            .configure { lottieAnimationView in
                lottieAnimationView.contentMode = .scaleAspectFit
                lottieAnimationView.shouldRasterizeWhenIdle = true
            }
    }
}
