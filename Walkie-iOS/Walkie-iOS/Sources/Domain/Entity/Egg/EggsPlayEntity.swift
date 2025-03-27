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
