//
//  ReviewsCalendarDto.swift
//  Walkie-iOS
//
//  Created by ahra on 3/26/25.
//

struct ReviewsCalendarDto: Codable {
    let reviews: [Review]
}

// MARK: - Review
struct Review: Codable {
    let reviewID, spotID: Int
    let spotName: String
    let distance: Double
    let step: Int
    let date, startTime, endTime: String
    let characterID, rank, type, characterClass: Int
    let pic: String?
    let reviewCD: Bool
    let review: String
    let rating: Int
    
    enum CodingKeys: String, CodingKey {
        case reviewID = "reviewId"
        case spotID = "spotId"
        case spotName, distance, step, date, startTime, endTime
        case characterID = "characterId"
        case rank, type, characterClass, pic
        case reviewCD = "reviewCd"
        case review, rating
    }
}
