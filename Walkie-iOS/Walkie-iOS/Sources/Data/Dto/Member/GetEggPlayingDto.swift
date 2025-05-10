//
//  GetEggPlayingDto.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Foundation

struct GetEggPlayingDto: Codable {
    let eggID, rank, needStep, nowStep: Int?
    let obtainedPosition, obtainedDate: String?
    let picked: Bool?
    let userCharacterID, characterRank, characterType, characterClass: Int?
    let memberID: Int?

    enum CodingKeys: String, CodingKey {
        case eggID = "eggId"
        case rank, needStep, nowStep, obtainedPosition, obtainedDate, picked
        case userCharacterID = "userCharacterId"
        case characterRank, characterType, characterClass
        case memberID = "memberId"
    }
}
