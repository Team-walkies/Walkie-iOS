//
//  GetCharactersDetailDto.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/29/25.
//

struct GetCharactersDetailDto: Codable {
    let characterCount: Int
    let rank: Int
    let type: Int
    let characterClass: Int
    let characterName: String
    let characterDescription: String
    let characterImageUrl: String
    let obtainedDetails: [ObtainedDetail]
    
    struct ObtainedDetail: Codable {
        let obtainedPosition: String
        let obtainedDate: String
    }
}
