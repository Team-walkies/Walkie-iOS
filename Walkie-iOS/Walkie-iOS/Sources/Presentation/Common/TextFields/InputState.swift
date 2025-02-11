//
//  InputState.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/10/25.
//

import SwiftUI

enum InputState {
    case `default`
    case focus
    case error
    
    var barColor: Color {
        switch self {
        case .default:
            .gray200
        case .focus:
            .blue300
        case .error:
            .red100
        }
    }
    
    var textColor: Color {
        switch self {
        case .default:
            .gray400
        case .focus, .error:
            .gray700
        }
    }
}
