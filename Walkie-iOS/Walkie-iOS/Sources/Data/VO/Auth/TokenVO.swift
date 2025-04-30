//
//  TokenVO.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import Foundation

struct TokenVO: Codable {
    let accessToken: AccessTokenVO
    let refreshToken: RefreshTokenVO
}
