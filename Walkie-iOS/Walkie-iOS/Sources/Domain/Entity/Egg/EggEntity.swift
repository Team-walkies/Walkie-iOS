//
//  EggEntity.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Foundation

struct EggEntity {
    let eggId: Int
    let eggType: EggLiterals
    let nowStep: Int
    let needStep: Int
    let isWalking: Bool
    let detail: EggDetailEntity?
}
