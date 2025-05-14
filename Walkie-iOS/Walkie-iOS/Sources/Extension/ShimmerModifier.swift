//
//  ShimmerModifier.swift
//  Walkie-iOS
//
//  Created by 고아라 on 5/14/25.
//

import SwiftUI

import WalkieCommon

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -1
    
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { proxy in
                    let w = proxy.size.width
                    let h = proxy.size.height
                    
                    LinearGradient(
                        gradient: Gradient(colors: [
                            WalkieCommonAsset.gray100.swiftUIColor,
                            WalkieCommonAsset.gray200.swiftUIColor,
                            WalkieCommonAsset.gray100.swiftUIColor
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: w * 3, height: h)
                    .offset(x: phase * w * 3)
                }
                .mask(content)
            }
            .onAppear {
                phase = -1
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
    }
}
