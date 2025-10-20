//
//  HealthDto.swift
//  Walkie-iOS
//
//  Created by 고아라 on 8/18/25.
//

enum AwardEnum: String, Codable {
    case received = "RECEIVED"
    case available = "AVAILABLE"
    case pending = "PENDING"
    case unknown
    
    var toEggButtonState: GetEggButtonState {
        switch self {
        case .received:
            return .received
        case .available:
            return .available
        case .pending, .unknown:
            return .pending
        }
    }
}

struct HealthDto: Codable {
    let responseDate: String
    let targetSteps, nowSteps: Int
    let award: AwardEnum
}
