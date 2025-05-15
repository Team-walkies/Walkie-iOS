//
//  EggLiterals.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/18/25.
//

import SwiftUI
import WalkieCommon

enum EggType: String, CaseIterable, Hashable {
    case normal = "일반"
    case rare = "희귀"
    case epic = "에픽"
    case legendary = "전설"
    
    var fontColor: Color {
        switch self {
        case .normal:
            WalkieCommonAsset.blue500.swiftUIColor
        case .rare:
            WalkieCommonAsset.green300.swiftUIColor
        case .epic:
            WalkieCommonAsset.orange300.swiftUIColor
        case .legendary:
            WalkieCommonAsset.purple300.swiftUIColor
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
    
    var walkCount: Int {
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
    
    var obtainRate: Int {
        switch self {
        case .normal:
            65
        case .rare:
            20
        case .epic:
            12
        case .legendary:
            3
        }
    }
    
    var characterObtainRate: [EggType: Int] {
        switch self {
        case .normal: [
            .normal: 80,
            .rare: 15,
            .epic: 4,
            .legendary: 1
        ]
        case .rare: [
            .normal: 50,
            .rare: 35,
            .epic: 10,
            .legendary: 5
        ]
        case .epic: [
            .normal: 20,
            .rare: 40,
            .epic: 30,
            .legendary: 10
        ]
        case .legendary: [
            .normal: 5,
            .rare: 25,
            .epic: 40,
            .legendary: 30
        ]
        }
    }
    
    var eggInformationText: String {
        switch self {
        case .normal:
            "자주 얻을 수 있는 알"
        case .rare:
            "평소보다 더 희귀한 알"
        case .epic:
            "보기 드문 비범한 알"
        case .legendary:
            "전설로만 듣던 알"
        }
    }
    
    var eggBackground: ImageResource {
        switch self {
        case .normal:
            .imgEggBack0
        case .rare:
            .imgEggBack1
        case .epic:
            .imgEggBack2
        case .legendary:
            .imgEggBack3
        }
    }
    
    var eggBackgroundColor: [Color] {
        switch self {
        case .normal:
            [
                WalkieCommonAsset.blue300.swiftUIColor,
                WalkieCommonAsset.blue200.swiftUIColor
            ]
        case .rare:
            [
                WalkieCommonAsset.green100.swiftUIColor,
                WalkieCommonAsset.green50.swiftUIColor
            ]
        case .epic:
            [
                WalkieCommonAsset.orange100.swiftUIColor,
                WalkieCommonAsset.orange100.swiftUIColor
            ]
        case .legendary:
            [
                WalkieCommonAsset.purple200.swiftUIColor,
                WalkieCommonAsset.purple100.swiftUIColor
            ]
        }
    }
    
    var eggBackEffect: ImageResource? {
        switch self {
        case .normal:
                nil
        case .rare:
                .imgEggBackEffect1
        case .epic:
                .imgEggBackEffect2
        case .legendary:
                .imgEggBackEffect3
        }
    }
    
    static func from(number: Int) -> EggType {
        switch number {
        case 0:
            return EggType.normal
        case 1:
            return EggType.rare
        case 2:
            return EggType.epic
        case 3:
            return EggType.legendary
        default:
            return EggType.normal
        }
    }
}
