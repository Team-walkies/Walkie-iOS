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
    let caloriesName, caloriesDescription, caloriesURL: String
    
    enum CodingKeys: String, CodingKey {
        case targetSteps, nowSteps, nowDistance, nowCalories, caloriesName, caloriesDescription
        case caloriesURL = "caloriesUrl"
    }
}
