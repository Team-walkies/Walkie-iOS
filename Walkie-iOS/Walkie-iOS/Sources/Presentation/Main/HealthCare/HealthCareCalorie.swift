//
//  HealthCareCalorie.swift
//  Walkie-iOS
//
//  Created by 고아라 on 8/19/25.
//

import SwiftUI

enum HealthCareCalorie {
    case air
    case candy
    case banana
    case gimbap
    case chicken
    case pasta
    
    var calorieImage: Image {
        switch self {
        case .air: return Image(.icCalorieAir)
        case .candy: return Image(.icCalorieCandy)
        case .banana: return Image(.icCalorieBanana)
        case .gimbap: return Image(.icCalorieGimbap)
        case .chicken: return Image(.icCalorieChicken)
        case .pasta: return Image(.icCaloriePasta)
        }
    }
    
    var calorieName: String {
        switch self {
        case .air: return "공기"
        case .candy: return "사탕 1개"
        case .banana: return "바나나 1개"
        case .gimbap: return "삼각김밥 1개"
        case .chicken: return "닭다리 1개"
        case .pasta: return "파스타 1접시"
        }
    }
    
    var calorieDescription: String {
        switch self {
        case .air: return "들숨 날숨~ 숨쉬기 운동 중!"
        case .candy: return "이제 몸이 풀렸어요!"
        case .banana: return "슬슬 운동한 느낌 나죠?"
        case .gimbap: return "편의점 인기템 클리어!"
        case .chicken: return "와, 간식 하나정도는 먹어도 되겠어요"
        case .pasta: return "대단해요! 당신의 다리에게 박수를!"
        }
    }
    
    static func from(steps: Int) -> HealthCareCalorie {
        let step = max(0, steps)
        switch step {
        case ..<200: return .air
        case 200..<2000: return .candy
        case 2000..<4000: return .banana
        case 4000..<6000: return .gimbap
        case 6000..<10000: return .chicken
        default: return .pasta
        }
    }
}
