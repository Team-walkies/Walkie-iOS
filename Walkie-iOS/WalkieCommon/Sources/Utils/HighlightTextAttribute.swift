//
//  HighlightTextAttribute.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/12/25.
//

import SwiftUI

public struct HighlightTextAttribute: View {
    let text: String
    let textColor: Color
    let font: FontLevel
    let highlightText: String
    let highlightColor: Color
    var highlightFont: FontLevel?
    
    public init(
        text: String,
        textColor: Color,
        font: FontLevel,
        highlightText: String,
        highlightColor: Color,
        highlightFont: FontLevel? = nil
    ) {
        self.text = text
        self.textColor = textColor
        self.font = font
        self.highlightText = highlightText
        self.highlightColor = highlightColor
        self.highlightFont = highlightFont == nil ? font : highlightFont
    }
    
    public var body: some View {
        highlightTextView
    }
    
    private var highlightTextView: some View {
        var attributeString = AttributedString(text)
        attributeString.foregroundColor = textColor
        attributeString.font = .walkieFont(font)
        if let range = attributeString.range(of: highlightText), let highlightFont {
            attributeString[range].foregroundColor = highlightColor
            attributeString[range].font = .walkieFont(highlightFont)
        }
        return Text(attributeString)
    }
}
