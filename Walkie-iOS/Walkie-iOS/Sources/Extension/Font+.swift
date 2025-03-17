//
//  Font+.swift
//  Walkie-iOS
//
//  Created by ahra on 3/17/25.
//

import SwiftUI

extension View {
    
    func font(_ font: FontLevel) -> some View {
        let fontSpacing = (font.lineHeight - font.fontSize) / 2
        
        return self
            .font(Font.walkieFont(font))
            .padding(.vertical, fontSpacing)
            .lineSpacing(fontSpacing * 2)
    }
}
