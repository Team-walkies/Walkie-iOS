//
//  GetEggPlayingDto.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Foundation

struct GetEggPlayingDto: Codable {
    let eggID, rank, needStep, nowStep: Int
    let obtainedPosition, obtainedDate: String
    let picked: Bool
    let userCharacterID: Int
    let memberID: Int?

    enum CodingKeys: String, CodingKey {
        case eggID = "eggId"
        case rank, needStep, nowStep, obtainedPosition, obtainedDate, picked
        case userCharacterID = "userCharacterId"
        case memberID = "memberId"
    }
}

extension GetEggPlayingDto: EmptyResponse {
    
    static let empty = GetEggPlayingDto(
        eggID: -1,
        rank: 0,
        needStep: 0,
        nowStep: 0,
        obtainedPosition: "",
        obtainedDate: "",
        picked: false,
        userCharacterID: -1,
        memberID: nil
    )
}
