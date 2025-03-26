//
//  InputState.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/10/25.
//

import SwiftUI

import WalkieCommon

enum InputState {
    case `default`
    case focus
    case error
    
    var barColor: Color {
        switch self {
        case .default:
            WalkieCommonAsset.gray200.swiftUIColor
        case .focus:
            WalkieCommonAsset.blue300.swiftUIColor
        case .error:
            WalkieCommonAsset.red100.swiftUIColor
        }
    }
    
    var textColor: Color {
        switch self {
        case .default:
            WalkieCommonAsset.gray400.swiftUIColor
        case .focus, .error:
            WalkieCommonAsset.gray700.swiftUIColor
        }
    }
}
