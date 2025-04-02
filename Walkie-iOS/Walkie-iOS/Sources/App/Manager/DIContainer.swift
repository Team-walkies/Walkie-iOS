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
    
    func buildHomeView() -> HomeView {
        return HomeView(viewModel: HomeViewModel(
            getEggPlayUseCase: DefaultGetEggPlayUseCase(
                memberRepository: memberRepo
            ),
            getCharacterPlayUseCase: DefaultGetWalkingCharacterUseCase(
                memberRepository: memberRepo
            ),
            getEggCountUseCase: DefaultGetEggCountUseCase(
                eggRepository: eggRepo
            ), getCharactersCountUseCase: DefaultGetCharactersCountUseCase(
                characterRepository: characterRepo
            )
        ))
    }
    
    func buildMapView() -> MapView {
        return MapView(viewModel: MapViewModel())
    }
    
    func buildMypageView() -> MypageMainView {
        return MypageMainView(viewModel: MypageMainViewModel())
    }
    
    func buildEggView() -> EggView {
        let eggVM = EggViewModel(
            eggUseCase: DefaultEggUseCase(
                eggRepository: eggRepo,
                memberRepository: memberRepo
            )
        )
        return EggView(viewModel: eggVM)
    }
    
    func buildAlarmListView() -> AlarmListView {
        return AlarmListView(viewModel: AlarmListViewModel())
    }
    
    func buildReviewView() -> ReviewView {
        return ReviewView(
            viewModel: ReviewViewModel(
                reviewUseCase: DefaultReviewUseCase(
                    reviewRepository: reviewRepo
                )
            )
        )
    }
    
    func buildCharacterView() -> CharacterView {
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
