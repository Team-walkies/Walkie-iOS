//
//  ReviewEntity.swift
//  Walkie-iOS
//
//  Created by ahra on 3/27/25.
//

struct ReviewListEntity: Codable {
    let reviewList: [ReviewEntity]
}

struct ReviewEntity: Codable {
    let reviewID, spotID: Int
    let spotName: String
    let distance: Double
    let step: Int
    let date, startTime, endTime: String
    let characterID, rank, type, characterClass: Int
    let pic: String
    let reviewCD: Bool
    let review: String
    let rating: Int
}
