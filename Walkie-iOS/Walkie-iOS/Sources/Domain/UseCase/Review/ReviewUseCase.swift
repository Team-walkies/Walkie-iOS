//
//  ReviewUseCase.swift
//  Walkie-iOS
//
//  Created by ahra on 3/27/25.
//

import Combine

protocol ReviewUseCase {
    
    func getReviewList(date: ReviewsCalendarDate) -> AnyPublisher<ReviewListEntity, NetworkError>
}
