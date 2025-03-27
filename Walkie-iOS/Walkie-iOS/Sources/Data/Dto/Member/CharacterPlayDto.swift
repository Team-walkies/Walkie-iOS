//
//  CharacterPlayDto.swift
//  Walkie-iOS
//
//  Created by ahra on 3/28/25.
//

struct CharacterPlayDto: Codable {
    let characterID, type, characterClass, rank: Int
    let count: Int?
    let picked: Bool

    enum CodingKeys: String, CodingKey {
        case characterID = "characterId"
        case type, characterClass, rank, count, picked
    }
}
