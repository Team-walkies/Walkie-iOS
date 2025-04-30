//
//  CharacterTarget.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/29/25.
//

import Moya

struct CharacterTarget: BaseTargetType {
    let path: String
    let method: Moya.Method
    let task: Moya.Task
    var headers: [String: String]? {
        APIConstants.hasTokenHeader
    }
    
    private init(
        path: String,
        method: Moya.Method,
        task: Moya.Task
    ) {
        self.path = path
        self.method = method
        self.task = task
    }
}

extension CharacterTarget {
    static func getCharactersDetail(characterId: CLong) -> CharacterTarget {
        CharacterTarget(
            path: URLConstant.charactersDetail(characterId: characterId),
            method: .get,
            task: .requestPlain
        )
    }
    
    static func getCharactersList(type: Int) -> CharacterTarget {
        CharacterTarget(
            path: URLConstant.characters,
            method: .get,
            task: .requestParameters(
                parameters: ["type": type],
                encoding: URLEncoding.queryString)
        )
    }
    
    static let getCharactersCount = CharacterTarget(
        path: URLConstant.charactersCount,
        method: .get,
        task: .requestPlain
    )
}
