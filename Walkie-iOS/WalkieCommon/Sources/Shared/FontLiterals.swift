//
//  FontLiterals.swift
//  Walkie-iOS
//
//  Created by ahra on 3/18/25.
//

import SwiftUI

public enum FontName: String {
    case PretendardBold = "Pretendard-Bold"
    case PretendardExtraBold = "Pretendard-ExtraBold"
    case PretendardMedium = "Pretendard-Medium"
}

public enum FontLevel {
    case H1, H2, H3, H4, H5, H6
    case B1, B2
    case C1, C2
    
    var font: Font {
        switch self {
        case .H1:
            return WalkieCommonFontFamily.Pretendard.extraBold.swiftUIFont(size: fontSize)
        case .H2, .H3, .H4, .H5, .H6:
            return WalkieCommonFontFamily.Pretendard.bold.swiftUIFont(size: fontSize)
        case .B1, .B2, .C1, .C2:
            return WalkieCommonFontFamily.Pretendard.medium.swiftUIFont(size: fontSize)
        }
    }
    
    var fontWeight: String {
        switch self {
        case .H1:
            return FontName.PretendardExtraBold.rawValue
        case .H2, .H3, .H4, .H5, .H6:
            return FontName.PretendardBold.rawValue
        case .B1, .B2, .C1, .C2:
            return FontName.PretendardMedium.rawValue
        }
    }
    
    var fontSize: CGFloat {
        switch self {
        case .H1: return 48
        case .H2: return 24
        case .H3: return 20
        case .H4: return 18
        case .H5, .B1: return 16
        case .H6, .B2: return 14
        case .C1: return 12
        case .C2: return 10
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .H1: return 58
        case .H2: return 34
        case .H3: return 30
        case .H4: return 28
        case .H5, .B1: return 24
        case .H6, .B2: return 20
        case .C1: return 16
        case .C2: return 12
        }
    }
}

extension Font {
    
    static func walkieFont(_ fontLevel: FontLevel) -> Font {
        return fontLevel.font
    }
}
