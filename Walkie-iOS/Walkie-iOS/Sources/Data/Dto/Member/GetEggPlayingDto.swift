//
//  GetEggPlayingDto.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Foundation

struct GetEggPlayingDto: Codable {
    let eggID, rank, characterClass, type, needStep, nowStep: Int
    let obtainedPosition, obtainedDate: String
    let picked: Bool
    let userCharacterID: Int
    let memberID: Int?

    enum CodingKeys: String, CodingKey {
        case eggID = "eggId"
        case rank, needStep, nowStep, obtainedPosition, obtainedDate, picked, type, characterClass
        case userCharacterID = "userCharacterId"
        case memberID = "memberId"
    }
}
