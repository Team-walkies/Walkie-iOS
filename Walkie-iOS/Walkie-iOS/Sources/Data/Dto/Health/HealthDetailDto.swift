//
//  HealthDetailDto.swift
//  Walkie-iOS
//
//  Created by 고아라 on 8/18/25.
//

struct HealthDetailDto: Codable {
    let targetSteps, nowSteps: Int
    let nowDistance: Double
    let nowCalories: Int
    
    enum CodingKeys: String, CodingKey {
        case targetSteps, nowSteps, nowDistance, nowCalories
    }
}
