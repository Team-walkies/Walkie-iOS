//
//  EggsPlayResponse.swift
//  Walkie-iOS
//
//  Created by ahra on 2/20/25.
//

struct EggsPlayResponse: Codable {
    let eggID, needStep, nowStep, rank: Int
    let characterID: Int
    
    enum CodingKeys: String, CodingKey {
        case eggID = "eggId"
        case needStep, nowStep, rank
        case characterID = "characterId"
    }
}

extension EggsPlayResponse {
    static func eggsPlayDummy() -> EggsPlayResponse {
        return EggsPlayResponse(eggID: 0, needStep: 1345, nowStep: 8423, rank: 2, characterID: 1)
    }
}
