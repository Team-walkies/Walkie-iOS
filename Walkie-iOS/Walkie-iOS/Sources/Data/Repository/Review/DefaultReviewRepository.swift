//
//  DefaultReviewRepository.swift
//  Walkie-iOS
//
//  Created by ahra on 3/27/25.
//

import Combine

final class DefaultReviewRepository {
    
    // MARK: - Dependency
    
    private let reviewService: ReviewService
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(reviewService: ReviewService) {
        self.reviewService = reviewService
    }
}

extension DefaultReviewRepository: ReviewRepository {
    
    func getReviewList(date: ReviewsCalendarDate) -> AnyPublisher<ReviewListEntity, any Error> {
        reviewService.getReviewCalendar(date: date)
            .map { dto in
                ReviewListEntity(
                    reviewList: dto.reviews.map { review in
                        ReviewEntity(
                            reviewID: review.reviewID,
                            spotID: review.spotID,
                            spotName: review.spotName,
                            distance: review.distance,
                            step: review.step,
                            date: review.date,
                            startTime: review.startTime,
                            endTime: review.endTime,
                            characterID: review.characterID,
                            rank: review.rank,
                            type: review.type,
                            characterClass: review.characterClass,
                            pic: review.pic ?? "",
                            reviewCD: review.reviewCD,
                            review: review.review,
                            rating: review.rating
                        )
                    }
                )
            }
            .eraseToAnyPublisher()
    }
}
