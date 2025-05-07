//
//  EggEntity.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Foundation

struct EggEntity {
    // 알 정보
    let eggId: Int
    let eggType: EggType
    let nowStep: Int
    let needStep: Int
    let isWalking: Bool
    let detail: EggDetailEntity?
    // 캐릭터 정보
    let characterType: CharacterType?
    let jellyFishType: JellyfishType?
    let dinoType: DinoType?
}
