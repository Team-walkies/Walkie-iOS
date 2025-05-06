//
//  GetProfileDto.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/5/25.
//

import Foundation

struct GetProfileDto: Decodable {
    let id, exploredSpot, recordedSpot, eggId, userCharacterId: Int?
    let providerId, provider, nickname, memberTier: String
    let isPublic: Bool
}
