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
        let eggService = DefaultEggService()
        let eggRepo = DefaultEggRepository(eggService: eggService)
        let homeUsecase = DefaultHomeUseCase(eggRepository: eggRepo)
        let homeVM = HomeViewModel(homeUseCase: homeUsecase)
        return homeVM
    }
    
    func registerEgg() -> EggView {
        let eggService = DefaultEggService()
        let memberService = DefaultMemberService()
        let eggRepo = DefaultEggRepository(eggService: eggService)
        let memberRepo = DefaultMemberRepository(memberService: memberService)
        let eggUsecase = DefaultEggUseCase(eggRepository: eggRepo, memberRepository: memberRepo)
        let eggVM = EggViewModel(eggUseCase: eggUsecase)
        let eggView = EggView(viewModel: eggVM)
        return eggView
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
