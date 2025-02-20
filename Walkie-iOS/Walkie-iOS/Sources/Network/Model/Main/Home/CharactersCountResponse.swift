//
//  CharactersCountResponse.swift
//  Walkie-iOS
//
//  Created by ahra on 2/20/25.
//

struct CharactersCountResponse: Codable {
    let charactersCount: Int
}

extension CharactersCountResponse {
    static func charactersCountDummy() -> CharactersCountResponse {
        return CharactersCountResponse(charactersCount: 3)
    }
}
