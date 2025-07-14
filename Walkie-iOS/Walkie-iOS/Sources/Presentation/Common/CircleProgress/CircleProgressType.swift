//
//  CircleProgressType.swift
//  Walkie-iOS
//
//  Created by 고아라 on 7/10/25.
//

import Foundation

enum CircleProgressType {
    case inCalendar
    case inMain
    
    var size: CGFloat {
        switch self {
        case .inCalendar:
            return 36
        case .inMain:
            return 260
        }
    }
    
    var lineWidth: CGFloat {
        switch self {
        case .inCalendar:
            return 5
        case .inMain:
            return 26
        }
    }
}
