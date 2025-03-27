//
//  ReviewService.swift
//  Walkie-iOS
//
//  Created by ahra on 3/26/25.
//

import Moya

import Combine
import CombineMoya

protocol ReviewService {
    
    func getReviewCalendar(date: ReviewsCalendarDate) -> AnyPublisher<ReviewsCalendarDto, Error>
}

final class DefaultReviewService: ReviewService {
    
    private let reviewProvider: MoyaProvider<ReviewTarget>
    
    init(reviewProvider: MoyaProvider<ReviewTarget> = MoyaProvider<ReviewTarget>(plugins: [NetworkLoggerPlugin()])) {
        self.reviewProvider = reviewProvider
    }
    
    func getReviewCalendar(date: ReviewsCalendarDate) -> AnyPublisher<ReviewsCalendarDto, Error> {
        reviewProvider.requestPublisher(.getReviewCalendar(date: date))
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(ReviewsCalendarDto.self)
    }
}
