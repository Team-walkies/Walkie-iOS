//
//  HealthUpdateDto.swift
//  Walkie-iOS
//
//  Created by 고아라 on 8/18/25.
//

struct HealthUpdateDto: Codable {
    let targetSteps, nowSteps, nowDistance, nowCalories: Int
}
