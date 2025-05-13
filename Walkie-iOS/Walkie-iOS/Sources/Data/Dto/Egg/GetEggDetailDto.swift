//
//  GetEggDetailDto.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Foundation

struct GetEggDetailDto: Codable {
    let rank, needStep, nowStep, userCharacterId, characterRank, characterType, characterClass: Int
    let obtainedPosition, obtainedDate: String
}
