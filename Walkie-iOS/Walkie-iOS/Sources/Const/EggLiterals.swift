//
//  EggLiterals.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/18/25.
//

import SwiftUI

enum EggLiterals: String {
    case normal = "일반",
         rare = "희귀",
         epic = "에픽",
         legendary = "전설"
    
    var fontColor: Color {
        switch self {
        case .normal:
            .blue500
        case .rare:
            .green300
        case .epic:
            .orange300
        case .legendary:
            .purple300
        }
    }
        
    var eggImage: ImageResource {
        switch self {
        case .normal:
            .imgEgg0
        case .rare:
            .imgEgg1
        case .epic:
            .imgEgg2
        case .legendary:
            .imgEgg3
        }
    }
    
    var walkCount: Double {
        switch self {
        case .normal:
            1000
        case .rare:
            3000
        case .epic:
            5000
        case .legendary:
            10000
        }
    }
    
}
