//
//  DeleteReviewUseCase.swift
//  Walkie-iOS
//
//  Created by 고아라 on 5/7/25.
//

import Combine

protocol DeleteReviewUseCase {
    func deleteReview(reviewId: Int) -> AnyPublisher<Void, NetworkError>
}
