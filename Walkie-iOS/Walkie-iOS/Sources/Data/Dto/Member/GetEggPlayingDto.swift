//
//  GetEggPlayingDto.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Foundation

struct GetEggPlayingDto: Codable {
    let eggId: Int
    let needStep: Int
    let nowStep: Int
    let rank: Int
    let characterId: Int
}
