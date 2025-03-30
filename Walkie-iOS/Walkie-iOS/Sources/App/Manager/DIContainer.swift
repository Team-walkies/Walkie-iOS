//
//  DIContainer.swift
//  Walkie-iOS
//
//  Created by ahra on 3/13/25.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()
    private init() {}
    
    private lazy var eggService = DefaultEggService()
    private lazy var memberService = DefaultMemberService()
    private lazy var reviewService = DefaultReviewService()
    private lazy var characterService = DefaultCharacterService()
    
    private lazy var eggRepo = DefaultEggRepository(eggService: eggService)
    private lazy var memberRepo = DefaultMemberRepository(memberService: memberService)
    private lazy var reviewRepo = DefaultReviewRepository(reviewService: reviewService)
    private lazy var characterRepo = DefaultCharacterRepository(characterService: characterService)
}

extension DIContainer {
    
    func registerHome() -> HomeViewModel {
        return HomeViewModel(
            homeUseCase: DefaultHomeUseCase(
                eggRepository: eggRepo,
                memberRepository: memberRepo
            )
        )
    }
    
    func registerEgg() -> EggView {
        let eggVM = EggViewModel(
            eggUseCase: DefaultEggUseCase(
                eggRepository: eggRepo,
                memberRepository: memberRepo
            )
        )
        return EggView(viewModel: eggVM)
    }
    
    func registerAlarmList() -> AlarmListView {
        return AlarmListView(viewModel: AlarmListViewModel())
    }
    
    func registerReview() -> ReviewView {
        return ReviewView(
            viewModel: ReviewViewModel(
                reviewUseCase: DefaultReviewUseCase(
                    reviewRepository: reviewRepo
                )
            )
        )
    }
    
    func registerCharacterView() -> CharacterView {
        return CharacterView(
            viewModel: CharacterViewModel(
                getCharactersListUseCase: DefaultGetCharactersListUseCase(
                    characterRepository: characterRepo
                ),
                getCharactersDetailUseCase: DefaultGetCharactersDetailUseCase(
                    characterRepository: characterRepo
                ),
                patchWalkingCharacterUseCase: DefaultPatchWalkingCharacterUseCase(
                    memberRepository: memberRepo
                )
            )
        )
    }
}
