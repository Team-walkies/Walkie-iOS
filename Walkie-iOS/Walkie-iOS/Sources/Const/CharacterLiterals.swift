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
    
    static func mapCharacterType(rank: Int, characterClass: Int) throws -> JellyfishType {
        switch rank {
        case 0:
            switch characterClass {
            case 0:
                return .defaultJellyfish
            case 1:
                return .red
            case 2:
                return .green
            case 3:
                return .purple
            case 4:
                return .pink
            default:
                throw NetworkError.responseDecodingError
            }
        case 1:
            switch characterClass {
            case 0:
                return .bunny
            case 1:
                return .starfish
            default:
                throw NetworkError.responseDecodingError
            }
        case 2:
            switch characterClass {
            case 0:
                return .shocked
            case 1:
                return .strawberry
            default:
                throw NetworkError.responseDecodingError
            }
        case 3:
            return .space
        default:
            throw NetworkError.responseDecodingError
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
    
    static func mapCharacterType(rank: Int, characterClass: Int) throws -> DinoType {
        switch rank {
        case 0:
            switch characterClass {
            case 0:
                return .defaultDino
            case 1:
                return .red
            case 2:
                return .mint
            case 3:
                return .purple
            case 4:
                return .pink
            default:
                throw NetworkError.responseDecodingError
            }
        case 1:
            switch characterClass {
            case 0:
                return .reindeer
            case 1:
                return .nessie
            default:
                throw NetworkError.responseDecodingError
            }
        case 2:
            switch characterClass {
            case 0:
                return .pancake
            case 1:
                return .melonSoda
            default:
                throw NetworkError.responseDecodingError
            }
        case 3:
            return .dragon
        default:
            throw NetworkError.responseDecodingError
        }
    }

}
