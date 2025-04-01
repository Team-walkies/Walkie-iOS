//
//  CharactersPlayResponse.swift
//  Walkie-iOS
//
//  Created by ahra on 2/20/25.
//

struct CharactersPlayEntity: Codable {
    let characterID, characterType, characterClass: Int

    enum CodingKeys: String, CodingKey {
        case characterID = "characterId"
        case characterType = "type"
        case characterClass = "class"
    }
}
