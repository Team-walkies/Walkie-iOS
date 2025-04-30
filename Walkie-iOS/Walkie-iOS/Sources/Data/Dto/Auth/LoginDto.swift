//
//  LoginDto.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/20/25.
//

import Foundation

struct LoginDto: Codable {
    let provider: String
    let accessToken: String
    let refreshToken: String
}
