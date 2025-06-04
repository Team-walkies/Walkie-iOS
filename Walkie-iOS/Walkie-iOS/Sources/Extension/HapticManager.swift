//
//  HapticManager.swift
//  Walkie-iOS
//
//  Created by 고아라 on 6/4/25.
//

import UIKit

final class HapticManager {
    
    static let shared = HapticManager()
    
    private init() { }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
}
