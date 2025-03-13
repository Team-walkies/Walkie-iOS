//
//  EggsCountResponse.swift
//  Walkie-iOS
//
//  Created by ahra on 2/20/25.
//

struct EggsCountEntity: Codable {
    let eggsCount: Int
}

extension EggsCountEntity {
    static func eggsCountDummy() -> EggsCountEntity {
        return EggsCountEntity(eggsCount: 2)
    }
}
