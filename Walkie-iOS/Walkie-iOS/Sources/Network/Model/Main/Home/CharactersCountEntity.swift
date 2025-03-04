//
//  CharactersCountResponse.swift
//  Walkie-iOS
//
//  Created by ahra on 2/20/25.
//

struct CharactersCountEntity: Codable {
    let charactersCount: Int
}

extension CharactersCountEntity {
    static func charactersCountDummy() -> CharactersCountEntity {
        return CharactersCountEntity(charactersCount: 3)
    }
}
