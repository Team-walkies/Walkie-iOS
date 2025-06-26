//
//  CharacterDetailEntity.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/29/25.
//

import Foundation
import SwiftUI

struct CharacterDetailEntity {
    let img: String
    let name: String
    let description: String
    let count: Int
    let rank: EggType
    let obtainEntity: [CharacterObtainEntity]
}

struct CharacterObtainEntity {
    let obtainedPosition: String
    let obtainedDate: String
}
