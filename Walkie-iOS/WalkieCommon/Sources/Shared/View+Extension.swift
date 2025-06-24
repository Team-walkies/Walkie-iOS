//
//  View+Extension.swift
//  Walkie-iOS
//
//  Created by ahra on 3/18/25.
//

import SwiftUI

public extension View {
    
    func font(_ font: FontLevel) -> some View {
        let fontSpacing = (font.lineHeight - font.fontSize) / 2
        return self
            .font(.walkieFont(font))
            .padding(.vertical, fontSpacing)
            .lineSpacing(fontSpacing * 2)
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner = .allCorners) -> some View {
        let topLeading = corners.contains(.topLeft) ? radius : 0
        let topTrailing = corners.contains(.topRight) ? radius : 0
        let bottomLeading = corners.contains(.bottomLeft) ? radius : 0
        let bottomTrailing = corners.contains(.bottomRight) ? radius : 0
        
        return clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: topLeading,
                bottomLeadingRadius: bottomLeading,
                bottomTrailingRadius: bottomTrailing,
                topTrailingRadius: topTrailing
            )
        )
    }
}
