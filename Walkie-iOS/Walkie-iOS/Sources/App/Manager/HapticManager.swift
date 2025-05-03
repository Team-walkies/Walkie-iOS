//
//  HapticManager.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/4/25.
//

import Foundation
import NotificationCenter

final class HapticManager {
    static let shared = HapticManager()
    
    func notificationSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
