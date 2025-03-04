//
//  EggsPlayResponse.swift
//  Walkie-iOS
//
//  Created by ahra on 2/20/25.
//

struct EggsPlayEntity: Codable {
    let eggID, needStep, nowStep, rank: Int
    let characterID: Int
    
    enum CodingKeys: String, CodingKey {
        case eggID = "eggId"
        case needStep, nowStep, rank
        case characterID = "characterId"
    }
}

extension EggsPlayEntity {
    static func eggsPlayDummy() -> EggsPlayEntity {
        return EggsPlayEntity(eggID: 0, needStep: 1345, nowStep: 8423, rank: 2, characterID: 1)
    }
}
