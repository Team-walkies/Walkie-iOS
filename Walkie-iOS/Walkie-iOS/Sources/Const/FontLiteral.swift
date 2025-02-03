//
//  FontLiteral.swift
//  Walkie-iOS
//
//  Created by ahra on 2/3/25.
//

import SwiftUI

enum FontName: String {
    case PretendardBold = "Pretendard-Bold"
    case PretendardExtraBold = "Pretendard-ExtraBold"
    case PretendardMedium = "Pretendard-Medium"
}

enum FontLevel {
    case H1
    case H2
    case H3
    case H4
    case H5
    case H6
    
    case B1
    case B2
    
    case C1
    case C2
}

extension FontLevel {
    
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
        case .H1:
            return 48
        case .H2:
            return 24
        case .H3:
            return 20
        case .H4:
            return 18
        case .H5, .B1:
            return 16
        case .H6, .B2:
            return 14
        case .C1:
            return 12
        case .C2:
            return 10
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .H1:
            return 58
        case .H2:
            return 34
        case .H3:
            return 30
        case .H4:
            return 28
        case .H5, .B1:
            return 24
        case .H6, .B2:
            return 20
        case .C1:
            return 16
        case .C2:
            return 12
        }
    }
}

extension Font {
    
    static func walkieFont(_ fontLevel: FontLevel) -> Font {
        return Font.custom(fontLevel.fontWeight, size: fontLevel.fontSize)
    }
}
