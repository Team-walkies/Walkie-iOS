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
    let headers: [String: String]?
    
    private init(
        path: String,
        method: Moya.Method,
        task: Moya.Task,
        headers: [String: String]?
    ) {
        self.path = path
        self.method = method
        self.task = task
        self.headers = headers
    }
}

extension CharacterTarget {
    static func getCharactersDetail(characterId: CLong) -> CharacterTarget {
        CharacterTarget(
            path: URLConstant.charactersDetail(characterId: characterId),
            method: .get,
            task: .requestPlain,
            headers: APIConstants.hasTokenHeader
        )
    }
    
    static func getCharactersList(type: Int) -> CharacterTarget {
        CharacterTarget(
            path: URLConstant.characters,
            method: .get,
            task: .requestParameters(
                parameters: ["type": type],
                encoding: URLEncoding.queryString),
            headers: APIConstants.hasTokenHeader
        )
    }
    
    static let getCharactersCount = CharacterTarget(
        path: URLConstant.charactersCount,
        method: .get,
        task: .requestPlain,
        headers: APIConstants.hasTokenHeader
    )
}
