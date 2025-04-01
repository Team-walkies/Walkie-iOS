//
//  StringLiterals.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/11/25.
//

import Foundation

enum StringLiterals {
    enum InputView {
        static let onlyText = "특수문자 및 기호는 사용할 수 없습니다"
    }
    enum CharacterView {
        static let dinoIntroductionText = "사람들과 뛰어놀고 싶어서 먼 과거에서 돌아온 다이노들"
        static let jellyfishIntroductionText = "육지에서 뛰고 싶은 꿈을 가진 낭만적인 해파리들"
    }
    enum Characters {
        static func getJellyfishDescription(type: JellyfishType) -> String {
            return switch type {
            case .defaultJellyfish:
                "무엇이든 시작에는 큰 용기가 필요해.\n나와 함께 첫걸음을 내딛어보자."
            case .red:
                "부끄러우니까 보지 마.\n얼굴 빨개진단 말이야."
            case .green:
                "매생이를 너무 많이 먹었나 봐.\n온몸이 초록빛이 됐어!"
            case .purple:
                "나는 겁이 많은 성격이야…\n그래서 얼굴이 늘 보랏빛으로 질려 있어…"
            case .pink:
                "몸을 분홍색으로 물들여 봤어.\n어때? 나 예뻐?"
            case .bunny:
                "나는 달에서 내려왔어.\n보름달이 뜨면 떡방아를 찧을 거야"
            case .starfish:
                "불가사리가 붙은 지 어언 100년.\n이것도 인연이니 같이 살지, 뭐."
            case .shocked:
                "빠직! 빠직!\n나와 함께라면 전기료 걱정은 없어."
            case .strawberry:
                "먹음직스러운 딸기 모찌…인 줄 알았지?\n먹지 않게 조심해!"
            case .space:
                "우주를 담은 광활한 몸, 무궁무진한 상상력.\n그야말로 나는 절대적인 존재."
            }
        }
        static func getDinoDescription(type: DinoType) -> String {
            return switch type {
            case .defaultDino:
                "나는 6천6백만 년을 기다려 너를 만났어.\n우린 함께 걸을 운명인가 봐."
            case .red:
                "화가 난다, 화가 나!\n온몸이 울그락불그락 빨개졌어!"
            case .mint:
                "민트 좋아해?\n내 옆에 있으면 상쾌해질 거야."
            case .purple:
                "추위를 많이 타서 온몸이 창백해졌어…\n옷이라도 입혀줘."
            case .pink:
                "응? 자색 고구마라고?\n나 고구마 아니고 공룡이야! "
            case .reindeer:
                "얼른 크리스마스가 왔으면 좋겠다.\n뭘 하는 지는 비밀이야."
            case .nessie:
                "난 수영이 특기야!\n아... 여기선 걸어야 하나?"
            case .pancake:
                "노릇노릇 맛있게 구워졌어.\n나랑 걸으면 배고파질지도 몰라!"
            case .melonSoda:
                "걷다 보면 덥지 않아?\n시원한 메론소다 마셔볼래?"
            case .dragon:
                "나는 신비롭고 강력한 힘을 가진 드래곤.\n어떤 것도 두렵지 않아."
            }
        }
    }
}
