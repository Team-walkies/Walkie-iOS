//
//  GetEggListDto.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Foundation

struct GetEggListDto: Codable {
    let eggs: [EggDto]
    
    struct EggDto: Codable {
        let eggId: Int
        let rank: Int
        let needStep: Int
        let nowStep: Int
        let characterId: Int
        let play: Bool
        let obtainedPosition: String
        let obtainedDate: String
    }
}
