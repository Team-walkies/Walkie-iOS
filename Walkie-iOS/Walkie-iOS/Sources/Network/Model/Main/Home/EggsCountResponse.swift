//
//  EggsCountResponse.swift
//  Walkie-iOS
//
//  Created by ahra on 2/20/25.
//

struct EggsCountResponse: Codable {
    let eggsCount: Int
}

extension EggsCountResponse {
    static func eggsCountDummy() -> EggsCountResponse {
        return EggsCountResponse(eggsCount: 2)
    }
}
