//
//  GetEggDetailDto.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Foundation

struct GetEggDetailDto: Codable {
    let rank: Int
    let needStep: Int
    let nowStep: Int
    let obtainedPosition: String
    let obtainedDate: String
}
