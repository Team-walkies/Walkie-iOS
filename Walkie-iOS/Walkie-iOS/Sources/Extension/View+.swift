//
//  View+.swift
//  Walkie-iOS
//
//  Created by ahra on 2/3/25.
//

import SwiftUI

extension View {
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func font(_ font: FontLevel) -> some View {
        let fontSpacing = (font.lineHeight - font.fontSize) / 2
        
        return self
            .font(Font.walkieFont(font))
            .padding(.vertical, fontSpacing)
            .lineSpacing(fontSpacing * 2)
    }
    
    func alignTo(_ alignment: Alignment) -> some View {
        modifier(AlignmentModifier(alignment: alignment))
    }
}

// MARK: - AlignmentModifier
struct AlignmentModifier: ViewModifier {
    let alignment: Alignment

    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            if alignment == .bottom || alignment == .bottomLeading || alignment == .bottomTrailing {
                Spacer(minLength: 0)
            }
            HStack(spacing: 0) {
                if alignment == .trailing || alignment == .bottomTrailing || alignment == .topTrailing {
                    Spacer(minLength: 0)
                }
                content
                if alignment == .leading || alignment == .bottomLeading || alignment == .topLeading {
                    Spacer(minLength: 0)
                }
            }
            if alignment == .top || alignment == .topLeading || alignment == .topTrailing {
                Spacer(minLength: 0)
            }
        }
    }
}
