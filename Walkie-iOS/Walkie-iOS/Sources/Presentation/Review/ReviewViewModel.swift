//
//  ReviewViewModel.swift
//  Walkie-iOS
//
//  Created by ahra on 3/27/25.
//

import SwiftUI
import Combine

final class ReviewViewModel: ViewModelable, WebMessageHandling {
    
    private let reviewUseCase: ReviewUseCase
    private let delReviewUseCase: DeleteReviewUseCase
    private var cancellables = Set<AnyCancellable>()
    
    @Published var state: ReviewViewState = .loading
    @Published var delState: ReviewDeleteState = .loading
    @Published var loadedReviewList: [ReviewState] = []
    @Published var reviewDateList: [String] = []
    @Published var selectedDate: Date = Date()
    
    var onPop: (() -> Void)?
    
    enum Action {
        case loadReviewList(startDate: String, endDate: String)
        case showReviewList(dateString: String)
        case deleteReview(reviewId: Int)
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
        let date: String
    }
    
    enum ReviewViewState {
        case loading
        case loaded([ReviewState]?)
        case error(String)
    }
    
    enum ReviewDeleteState: Equatable {
        case loading
        case loaded
        case error(String)
    }
    
    func action(_ action: Action) {
        switch action {
        case .loadReviewList(let startDate, let endDate):
            getReviewList(startDate: startDate, endDate: endDate)
        case .showReviewList(dateString: let dateString):
            showReviewList(dateString: dateString)
        case .deleteReview(reviewId: let reviewId):
            delReview(reviewId: reviewId)
        }
    }
    
    func handleWebMessage(_ message: WebMessage) {
        switch message.type {
        case .unauthorizedFromWeb:
            NotificationCenter.default.post(
                name: .reissueFailed,
                object: nil
            )
        case .finishReviewModify:
            onPop?()
        default:
            break
        }
    }
    
    init(
        reviewUseCase: ReviewUseCase,
        delReviewUseCase: DeleteReviewUseCase
    ) {
        self.reviewUseCase = reviewUseCase
        self.delReviewUseCase = delReviewUseCase
    }
    
    func setWebURL(reviewInfo: ReviewItemId) throws -> URLRequest {
        let token = (try? TokenKeychainManager.shared.getAccessToken())
        var components = URLComponents(string: Config.webURL + "/rewrite")
        components?.queryItems = [
            URLQueryItem(name: "reviewId", value: "\(reviewInfo.reviewId)"),
            URLQueryItem(name: "spotId", value: "\(reviewInfo.spotId)"),
            URLQueryItem(name: "token", value: token)
        ]
        guard let url = components?.url else {
            throw WebURLError.invalidURL
        }
        return URLRequest(url: url)
    }
    
    func getReviewList(startDate: String, endDate: String) {
        let date = ReviewsCalendarDate(startDate: startDate, endDate: endDate)
        self.reviewUseCase
            .getReviewList(date: date)
            .walkieSink(
                with: self,
                receiveValue: { viewModel, reviewList in
                    let processedReviews = reviewList.reviewList.map { viewModel.processReviewEntity($0) }
                    viewModel.loadedReviewList = processedReviews
                    viewModel.reviewDateList = Array(Set(reviewList.reviewList.map { $0.date })).sorted()
                    self.showReviewList(dateString: self.selectedDate.convertToDateString())
                }, receiveFailure: { _, error in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.state = .error(errorMessage)
                })
            .store(in: &cancellables)
    }
    
    func showReviewList(dateString: String) {
        self.state = .loaded(self.loadedReviewList.filter { review in
            review.date == dateString
        })
    }
    
    func delReview(reviewId: Int) {
        if reviewId < 0 { return }
        
        delReviewUseCase.deleteReview(reviewId: reviewId)
            .walkieSink(
                with: self,
                receiveValue: { _, _ in
                    self.delState = .loaded
                }, receiveFailure: { _, error in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.delState = .error(errorMessage)
                }
            )
            .store(in: &cancellables)
    }
}

private extension ReviewViewModel {
    
    func processReviewEntity(_ entity: ReviewEntity) -> ReviewState {
        let walkTime: String = {
            guard
                let start = formatTimeString(entity.startTime),
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
            rating: entity.rating,
            date: entity.date
        )
    }
    
    func timeDifferenceInMinutes(startTime: String, endTime: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        if
            let start = dateFormatter.date(from: startTime),
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
