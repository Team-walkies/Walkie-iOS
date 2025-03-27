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
}

extension DIContainer {
    
    func registerHome() -> HomeViewModel {
        let homeService = DefaultHomeService()
        let homeRepo = DefaultHomeRepository(homeService: homeService)
        let homeUsecase = DefaultHomeUseCase(homeRepository: homeRepo)
        let homeVM = HomeViewModel(homeUseCase: homeUsecase)
        return homeVM
    }
    
    func registerEgg() -> EggViewModel {
        let eggService = DefaultEggService()
        let memberService = DefaultMemberService()
        let eggRepo = DefaultEggRepository(eggService: eggService)
        let memberRepo = DefaultMemberRepository(memberService: memberService)
        let eggUsecase = DefaultEggUseCase(eggRepository: eggRepo, memberRepository: memberRepo)
        let eggVM = EggViewModel(eggUseCase: eggUsecase)
        return eggVM
    }
    
    func registerAlarmList() -> AlarmListView {
        let alarmListVM = AlarmListViewModel()
        let alarmListView = AlarmListView(viewModel: alarmListVM)
        return alarmListView
    }
    
    func registerReview() -> ReviewView {
        let reviewService = DefaultReviewService()
        let reviewRepo = DefaultReviewRepository(reviewService: reviewService)
        let reviewUseCase = DefaultReviewUseCase(reviewRepository: reviewRepo)
        let reviewVM = ReviewViewModel(reviewUseCase: reviewUseCase)
        return ReviewView(viewModel: reviewVM)
    }
}
