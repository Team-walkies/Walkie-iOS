//
//  CharacterLiterals.swift
//  Walkie-iOS
//
//  Created by ahra on 2/20/25.
//

import SwiftUI

enum CharacterType: String, CaseIterable {
    case jellyfish = "해파리"
    case dino = "다이노"
}

enum JellyfishType: String, CaseIterable {
    case defaultJellyfish = "해파리"
    case red = "빨간 해파리"
    case green = "초록 해파리"
    case purple = "보라 해파리"
    case pink = "분홍 해파리"
    case bunny = "토끼 해파리"
    case starfish = "불가사리 해파리"
    case shocked = "벼직 해파리"
    case strawberry = "딸기모찌 해파리"
    case space = "우주 해파리"
    
    func getCharacterImage() -> ImageResource {
        let index = JellyfishType.allCases.firstIndex(of: self) ?? 0
        return ImageResource(name: "img_jellyfish\(index)", bundle: .main)
    }
    
    func getCharacterRank() -> EggType {
        switch self {
        case .defaultJellyfish, .red, .green, .purple, .pink:
            .normal
        case .bunny, .starfish:
            .rare
        case .shocked, .strawberry:
            .epic
        case .space:
            .legendary
        }
    }
    
    private static let mapTable: [Int: [Int: JellyfishType]] = [
        0: [
            0: .defaultJellyfish,
            1: .red,
            2: .green,
            3: .purple,
            4: .pink
        ],
        1: [
            0: .bunny,
            1: .starfish
        ],
        2: [
            0: .shocked,
            1: .strawberry
        ]
    ]
    
    static func mapCharacterType(
        rank: Int,
        characterClass: Int
    ) throws -> JellyfishType {
        if rank == 3 {
            return .space
        }
        guard
            let classMap = mapTable[rank],
            let jelly    = classMap[characterClass]
        else {
            throw NetworkError.responseDecodingError
        }
        return jelly
    }
}

enum DinoType: String, CaseIterable {
    case defaultDino = "다이노"
    case red = "빨간 다이노"
    case mint = "민트 다이노"
    case purple = "보라 다이노"
    case pink = "분홍 다이노"
    case reindeer = "순록 다이노"
    case nessie = "네시 다이노"
    case pancake = "팬케이크 다이노"
    case melonSoda = "메론소다 다이노"
    case dragon = "드래곤 다이노"
    
    func getCharacterImage() -> ImageResource {
        let index = DinoType.allCases.firstIndex(of: self) ?? 0
        return ImageResource(name: "img_dino\(index)", bundle: .main)
    }
    
    func getCharacterRank() -> EggType {
        switch self {
        case .defaultDino, .red, .mint, .purple, .pink:
            .normal
        case .reindeer, .nessie:
            .rare
        case .pancake, .melonSoda:
            .epic
        case .dragon:
            .legendary
        }
    }
    
    private static let mapTable: [Int: [Int: DinoType]] = [
        0: [
            0: .defaultDino,
            1: .red,
            2: .mint,
            3: .purple,
            4: .pink
        ],
        1: [
            0: .reindeer,
            1: .nessie
        ],
        2: [
            0: .pancake,
            1: .melonSoda
        ]
    ]
    
    static func mapCharacterType(rank: Int, characterClass: Int) throws -> DinoType {
        if rank == 3 {
            return .dragon
        }
        guard
            let classMap = mapTable[rank],
            let dino     = classMap[characterClass]
        else {
            throw NetworkError.responseDecodingError
        }
        return dino
    }
}
