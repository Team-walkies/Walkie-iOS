//
//  ReviewViewModel.swift
//  Walkie-iOS
//
//  Created by ahra on 3/27/25.
//

import SwiftUI

import Combine

final class ReviewViewModel: ViewModelable {
    
    private let reviewUseCase: ReviewUseCase
    private var cancellables = Set<AnyCancellable>()
    
    @Published var state: ReviewViewState = .loading
    
    enum Action {
        case calendarWillAppear
    }
    
    struct ReviewState {
        let review: ReviewEntity
    }
    
    enum ReviewViewState {
        case loading
        case loaded(ReviewListEntity)
        case error(String)
    }
    
    func action(_ action: Action) {
        switch action {
        case .calendarWillAppear:
            getReviewList()
        }
    }
    
    init(reviewUseCase: ReviewUseCase) {
        self.reviewUseCase = reviewUseCase
    }
    
    func getReviewList() {
        let date  = ReviewsCalendarDate(startDate: "", endDate: "")
        self.reviewUseCase.getReviewList(date: date)
            .walkieSink(
                with: self,
                receiveValue: { _, reviewList in
                    self.state = .loaded(reviewList)
                }, receiveFailure: { _, error in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.state = .error(errorMessage)
                })
            .store(in: &cancellables)
    }
}
