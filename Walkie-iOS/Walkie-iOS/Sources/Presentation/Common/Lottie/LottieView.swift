//
//  LottieView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/9/25.
//

import SwiftUI
import Lottie

struct WalkieLottieView: View {
    let lottie: WalkieLottie
    let isPlaying: Bool
    var isLoop: Bool = false

    var body: some View {
        LottieView(
            animation: .named(lottie.filename)
        )
        .playbackMode(
            isPlaying
            ? .playing(.fromProgress(0, toProgress: 1, loopMode: isLoop ? .loop : .playOnce))
            : .paused
        )
        .configure { lottieAnimationView in
            lottieAnimationView.contentMode = .scaleAspectFit
            lottieAnimationView.shouldRasterizeWhenIdle = true
        }
    }
}
