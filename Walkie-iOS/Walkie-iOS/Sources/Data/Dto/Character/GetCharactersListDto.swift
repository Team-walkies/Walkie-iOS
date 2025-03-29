//
//  GetCharactersListDto.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/29/25.
//

struct GetCharactersListDto: Codable {
    let characters: [CharacterDto]
    struct CharacterDto: Codable {
        let characterId: CLong
        let type, characterClass, rank, count: Int
        let picked: Bool
    }
}
