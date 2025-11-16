//
//  PostHealthCareEggAwardRequestDto.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 10/8/25.
//

import Foundation

struct PostHealthCareEggAwardRequestDto: Codable {
    let latitude: Double
    let longitude: Double
    let healthcareEggAcquiredAt: String
}
