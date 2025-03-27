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
        let reviewID, spotID: Int
        let spotName: String
        let distance: String
        let step: Int
        let walkTime: String
        let duration: String
        let characterID, rank, type, characterClass: Int
        let pic: String
        let reviewCD: Bool
        let review: String
        let rating: Int
    }
    
    enum ReviewViewState {
        case loading
        case loaded([ReviewState])
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
                    let processedReviews = reviewList.reviewList.map { self.processReviewEntity($0) }
                    self.state = .loaded(processedReviews)
                }, receiveFailure: { _, error in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.state = .error(errorMessage)
                })
            .store(in: &cancellables)
    }
}

private extension ReviewViewModel {
    
    func processReviewEntity(_ entity: ReviewEntity) -> ReviewState {
        
        let walkTime: String = {
            guard let start = formatTimeString(entity.startTime),
                let end = formatTimeString(entity.endTime) else { return "" }
            return "\(start) ~ \(end)"
        }()
        
        let formattedDistance = String(format: "%.1f", entity.distance) + "km"
        let duration = timeDifferenceInMinutes(startTime: entity.startTime, endTime: entity.endTime).map { "\($0)m" }
        
        return ReviewState(
            reviewID: entity.reviewID,
            spotID: entity.spotID,
            spotName: entity.spotName,
            distance: formattedDistance,
            step: entity.step,
            walkTime: walkTime,
            duration: duration ?? "",
            characterID: entity.characterID,
            rank: entity.rank,
            type: entity.type,
            characterClass: entity.characterClass,
            pic: entity.pic,
            reviewCD: entity.reviewCD,
            review: entity.review,
            rating: entity.rating
        )
    }
    
    func timeDifferenceInMinutes(startTime: String, endTime: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        if let start = dateFormatter.date(from: startTime),
            let end = dateFormatter.date(from: endTime) {
            let difference = end.timeIntervalSince(start)
            return Int(difference / 60)
        }
        return nil
    }
    
    func formatTimeString(_ timeString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm:ss"
        
        guard let date = inputFormatter.date(from: timeString) else {
            return ""
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.dateFormat = "a h:mm"
        
        return outputFormatter.string(from: date)
    }
}
