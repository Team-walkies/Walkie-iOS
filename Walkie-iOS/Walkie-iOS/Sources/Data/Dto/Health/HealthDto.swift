//
//  HealthDto.swift
//  Walkie-iOS
//
//  Created by 고아라 on 8/18/25.
//

struct HealthDto: Codable {
    let responseDate: String
    let targetSteps, nowSteps: Int
    let award: Bool
}
