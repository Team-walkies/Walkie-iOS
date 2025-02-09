//
//  LottieView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/9/25.
//

import SwiftUI

import Lottie

struct LottieView: UIViewRepresentable {
    
    let fileName: String
    
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: fileName)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        return animationView
    }
    
    func updateUIView(_ uiView: LottieAnimationView, context: Context) {
        uiView.play()
    }
}
