//
//  OnboardingPageStruct.swift
//  Walkie-iOS
//
//  Created by ahra on 2/28/25.
//

import SwiftUI

struct OnboardingPageStruct {
    let image: ImageResource
    let title: String
    let subTitle: String
}

extension OnboardingPageStruct {
    
    static func makeOnboardingPage() -> [OnboardingPageStruct] {
        return [
            OnboardingPageStruct(
                image: .imgOnboarding1,
                title: "내 주변 스팟에서 알 획득",
                subTitle: "스팟에 도착하면, 랜덤하게\n네 가지 알 중 하나를 획득할 수 있어요."
            ),
            OnboardingPageStruct(
                image: .imgOnboarding2,
                title: "걷다보면 알 부화",
                subTitle: "걸으며 알을 부화시켜보세요.\n어떤 캐릭터가 부화할까요?"
            ),
            OnboardingPageStruct(
                image: .imgOnboarding3,
                title: "캐릭터와 함께 떠나는 모험",
                subTitle: "스팟까지 안내해 줄 캐릭터를 선택하고\n함께 모험을 떠나 보세요."
            ),
            OnboardingPageStruct(
                image: .imgOnboarding4,
                title: "나만의 모험 기록",
                subTitle: "스팟을 모험하며 얻은\n경험을 모아보세요."
            )
        ]
    }
}
