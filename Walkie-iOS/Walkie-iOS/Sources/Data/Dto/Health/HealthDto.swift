//
//  HealthDto.swift
//  Walkie-iOS
//
//  Created by 고아라 on 8/18/25.
//

enum AwardEnum: String, Codable {
    case received = "RECEIVED"
    case pending = "PENDING"
    case missed = "MISSED"
    
    var toEggButtonState: GetEggButtonState {
        switch self {
        case .received:
            .received
        case .pending:
            .pending // available은 나중에 걸음 수와 비교하여 할당
        case .missed:
            .missed
        }
    }
}

struct HealthDto: Codable {
    let responseDate: String
    let targetSteps, nowSteps: Int
    let award: AwardEnum
}
