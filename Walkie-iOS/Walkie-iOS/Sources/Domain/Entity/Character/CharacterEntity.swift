//
//  CharacterEntity.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/29/25.
//

import Foundation

struct CharacterEntity {
    let type: CharacterType
    let jellyfishType: JellyfishType?
    let dinoType: DinoType?
    let count: Int
    let isWalking: Bool
    let obtainedDetails: [CharacterDetailEntity]?
}
