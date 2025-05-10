//
//  DefaultDeleteReviewUseCase.swift.swift
//  Walkie-iOS
//
//  Created by 고아라 on 5/7/25.
//

import Combine

final class DefaultDeleteReviewUseCase: BaseReviewUseCase, DeleteReviewUseCase {
    
    func deleteReview(reviewId: Int) -> AnyPublisher<Void, NetworkError> {
        reviewRepository.delReview(reviewId: reviewId)
            .mapToNetworkError()
    }
}
