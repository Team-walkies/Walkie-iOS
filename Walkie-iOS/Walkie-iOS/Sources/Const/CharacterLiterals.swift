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
    case strawberry = "딸기꼬치 해파리"
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
}

extension CharacterType {
    
    static func getCharacterName(type: Int, characterClass: Int) -> String? {
        switch type {
        case 1:
            let jellyfishTypes: [JellyfishType] = [
                .defaultJellyfish, .red, .green, .purple, .pink, .bunny,
                .starfish, .shocked, .strawberry, .space
            ]
            return jellyfishTypes[safe: characterClass]?.rawValue
            
        case 2:
            let dinoTypes: [DinoType] = [
                .defaultDino, .red, .mint, .purple, .pink, .reindeer,
                .nessie, .pancake, .melonSoda, .dragon
            ]
            return dinoTypes[safe: characterClass]?.rawValue
            
        default:
            return nil
        }
    }
    
    static func getCharacterImage(type: Int, characterClass: Int) -> ImageResource? {
        switch type {
        case 1:
            return ImageResource(name: "img_jellyfish\(characterClass)", bundle: .main)
            
        case 2:
            return ImageResource(name: "img_dino\(characterClass)", bundle: .main)
        default:
            return nil
        }
    }
    
    static func mapCharacterType(
        requestedType: CharacterType,
        type: Int,
        rank: Int,
        characterClass: Int) -> (any CaseIterable)? {
        if requestedType == .jellyfish && type == 1 { return nil }
        let index = rank == 0 ? characterClass : characterClass + 5 + (rank - 1) * 2
        return type == 0 ? JellyfishType.allCases[index] : DinoType.allCases[index]
    }
}
