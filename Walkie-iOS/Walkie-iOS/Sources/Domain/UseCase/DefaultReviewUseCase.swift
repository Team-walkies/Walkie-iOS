//
//  DefaultReviewUseCase.swift
//  Walkie-iOS
//
//  Created by ahra on 3/27/25.
//

import Combine

final class DefaultReviewUseCase {
    
    // MARK: - Dependency
    
    private let reviewRepository: ReviewRepository
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(reviewRepository: ReviewRepository) {
        self.reviewRepository = reviewRepository
    }
}

extension DefaultReviewUseCase: ReviewUseCase {
    
    func getReviewList(date: ReviewsCalendarDate) -> AnyPublisher<ReviewListEntity, NetworkError> {
        reviewRepository.getReviewList(date: date)
            .mapToNetworkError()
    }
}
