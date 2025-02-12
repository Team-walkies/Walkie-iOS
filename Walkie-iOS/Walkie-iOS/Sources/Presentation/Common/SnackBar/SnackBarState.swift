//
//  SnackBarState.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/12/25.
//

import SwiftUI

enum SnackBarState {
    case noButton
    case blackButton
    case blueButton
    
    var buttonColor: Color {
        switch self {
        case .noButton:
            return .clear
        case .blackButton:
            return .gray900
        case .blueButton:
            return .blue300
        }
    }
}
