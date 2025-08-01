//
//  CharactersPlayResponse.swift
//  Walkie-iOS
//
//  Created by ahra on 2/20/25.
//

struct CharactersPlayEntity: Codable {
    let characterId, characterRank, characterType, characterClass: Int

    enum CodingKeys: String, CodingKey {
        case characterId = "characterId"
        case characterRank = "characterRank"
        case characterType = "type"
        case characterClass = "class"
    }
}
