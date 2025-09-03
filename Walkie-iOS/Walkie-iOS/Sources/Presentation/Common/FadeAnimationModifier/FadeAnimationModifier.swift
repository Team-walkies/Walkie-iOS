//
//  FadeAnimationModifier.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 9/2/25.
//

import SwiftUI

struct FadeAnimationModifier: ViewModifier {
    let value: Bool
    let duration: Double
    let animationType: Animation
    
    func body(content: Content) -> some View {
        content
            .opacity(value ? 1 : 0)
            .animation(animationType, value: value)
    }
}

extension View {
    func fadeAnimation(_ value: Bool, duration: Double = 0.3, animationType: Animation = .linear) -> some View {
        modifier(FadeAnimationModifier(value: value, duration: duration, animationType: animationType))
    }
}
