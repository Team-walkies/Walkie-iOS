//
//  PatchProfileRequestDto.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import Foundation

struct PatchProfileRequestDto: Codable {
    let id: Int
    let providerId: String
    let provider: String
    let nickname: String
    let exploredSpot: Int
    let recordedSpot: Int
    let isPublic: Bool
    let memberTier: String
    let eggId: Int
    let userCharacterId: Int
}
