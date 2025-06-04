//
//  ButtonStyle+.swift
//  Walkie-iOS
//
//  Created by 고아라 on 6/4/25.
//

import SwiftUI

struct WalkieTouchEffect: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let pressedScale: CGFloat = 0.8
        let normalScale: CGFloat = 1.0
        
        let pressAnimation = Animation.spring(
            response: 0.15,
            dampingFraction: 0.6,
            blendDuration: 0
        )
        let releaseAnimation = Animation.spring(
            response: 0.5,
            dampingFraction: 0.7,
            blendDuration: 0
        )
        
        return configuration.label
            .scaleEffect(configuration.isPressed ? pressedScale : normalScale)
            .animation(
                configuration.isPressed
                ? pressAnimation
                : releaseAnimation,
                value: configuration.isPressed
            )
            .onChange(of: configuration.isPressed) { _, isPressed in
                if isPressed {
                    HapticManager.shared.impact(style: .light)
                }
            }
    }
}

struct HapticButtonStyle: ButtonStyle {
    let style: UIImpactFeedbackGenerator.FeedbackStyle
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .onChange(of: configuration.isPressed) { _, pressed in
                if pressed {
                    HapticManager.shared.impact(style: style)
                }
            }
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
