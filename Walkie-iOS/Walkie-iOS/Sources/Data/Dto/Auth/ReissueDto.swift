//
//  RefreshAccessTokenDto.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import Foundation

struct ReissueDto: Codable {
    let provider: String
    let refreshToken: String
    let accessToken: String
}
