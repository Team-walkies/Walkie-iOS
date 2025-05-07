//
//  BaseReviewUseCase.swift
//  Walkie-iOS
//
//  Created by 고아라 on 5/7/25.
//

import Combine

class BaseReviewUseCase {
    
    // MARK: - Dependency
    
    let reviewRepository: ReviewRepository
    
    // MARK: - Properties
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(reviewRepository: ReviewRepository) {
        self.reviewRepository = reviewRepository
    }
}
