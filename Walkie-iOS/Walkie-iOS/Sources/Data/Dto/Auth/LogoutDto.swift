//
//  LogoutDto.swift
//  Walkie-iOS
//
//  Created by ahra on 4/26/25.
//

struct LogoutDto: Codable {
    let id: Int
    let providerID, provider, nickname: String
    let exploredSpot, recordedSpot: Int
    let isPublic: Bool
    let memberTier: String
    let eggID: Int?
    let userCharacterID: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case providerID = "providerId"
        case provider, nickname, exploredSpot, recordedSpot, isPublic, memberTier
        case eggID = "eggId"
        case userCharacterID = "userCharacterId"
    }
}
