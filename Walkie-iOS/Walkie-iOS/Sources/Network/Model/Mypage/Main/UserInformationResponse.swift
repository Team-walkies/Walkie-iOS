//
//  UserInformationResponse.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/1/25.
//

import Foundation

typealias UserInformationResponse = WalkieResponse<UserInformationItem>

struct UserInformationItem: Decodable {
    let memberId: Double
    let memberEmail: String
    let nickname: String
    let exploredSpotCount: Int
    let isPublic: Bool
    let memberTier: String
}

extension UserInformationResponse {
    static func getDummyData() -> Self {
        return UserInformationResponse(
            status: 200,
            message: "성공 메시지",
            data: UserInformationItem(
                memberId: 12345678,
                memberEmail: "walkie@gmail.com",
                nickname: "poolkim",
                exploredSpotCount: 5,
                isPublic: true,
                memberTier: "초보워키"
            )
        )
    }
}
