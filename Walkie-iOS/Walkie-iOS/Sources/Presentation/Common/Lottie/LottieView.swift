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

struct LottieView: UIViewRepresentable {
    
    let fileType: WalkieLottie
    
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: fileType.filename)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        return animationView
    }
    
    func updateUIView(_ uiView: LottieAnimationView, context: Context) {
        uiView.play()
    }
}
