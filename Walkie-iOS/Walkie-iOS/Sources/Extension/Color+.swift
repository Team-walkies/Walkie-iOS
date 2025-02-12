//
//  Color+.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/12/25.
//

import SwiftUI

extension Color {
    init(hex: String, alpha: Double = 1) {
        let hex = hex.trimmingCharacters(in: ["#"])
        guard hex.count == 6, let int = UInt32(hex, radix: 16) else {
            self = .clear
            return
        }
        
        self.init(
            .sRGB,
            red: Double((int >> 16) & 0xFF) / 255,
            green: Double((int >> 8) & 0xFF) / 255,
            blue: Double(int & 0xFF) / 255,
            opacity: alpha
        )
    }
}
