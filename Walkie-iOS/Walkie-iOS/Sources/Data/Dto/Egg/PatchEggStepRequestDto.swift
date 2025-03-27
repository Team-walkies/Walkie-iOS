//
//  PatchEggStepRequestDto.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Foundation

struct PatchEggStepRequestDto: Codable {
    let eggId: Int
    let nowStep: Int
    let latitude: Double?
    let longitude: Double?
}
