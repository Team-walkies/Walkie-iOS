//
//  ButtonStyle+.swift
//  Walkie-iOS
//
//  Created by 고아라 on 6/4/25.
//

import SwiftUI

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
