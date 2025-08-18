//
//  HealthRequestDto.swift
//  Walkie-iOS
//
//  Created by 고아라 on 8/18/25.
//

struct HealthRequestDto: Codable {
    let targetSteps, nowSteps, nowDistance, nowCalories: Int
    let nowDay: String
}
