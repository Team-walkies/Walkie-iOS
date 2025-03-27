//
//  ReviewViewModel.swift
//  Walkie-iOS
//
//  Created by ahra on 3/27/25.
//

import SwiftUI

import Combine

final class ReviewViewModel: ViewModelable {
    
    @Published var state: ReviewViewState = .loading
    
    enum Action {
        case calendarWillAppear
    }
    
    struct ReviewState {
        let review: Review
    }
    
    enum ReviewViewState {
        case loading
        case loaded([Review])
        case error(String)
    }
    
    func action(_ action: Action) {
        switch action {
        case .calendarWillAppear:
            getReviewList()
        }
    }
    
    func getReviewList() {
        let reviewList: [Review] = [
            Review(
                reviewID: 6,
                spotID: 1,
                spotName: "여기어때",
                distance: 3.5,
                step: 3000,
                date: "2025-03-03",
                startTime: "16:02:29",
                endTime: "16:32:29",
                characterID: 38,
                rank: 1,
                type: 0,
                characterClass: 1,
                pic: "files/d73f8760-12d1-454d-bf1a-450c04a6139d20250311_205540.png",
                reviewCD: true,
                review: "재밌었다.",
                rating: 4
            ),
            Review(
                reviewID: 8,
                spotID: 1,
                spotName: "여기어때",
                distance: 3.5,
                step: 3000,
                date: "2025-03-03",
                startTime: "16:02:29",
                endTime: "16:32:29",
                characterID: 38,
                rank: 1,
                type: 0,
                characterClass: 1,
                pic: "files/d73f8760-12d1-454d-bf1a-450c04a6139d20250311_205540.png",
                reviewCD: true,
                review: "재밌었다.",
                rating: 4
            )
        ]
        state = .loaded(reviewList)
    }
}
