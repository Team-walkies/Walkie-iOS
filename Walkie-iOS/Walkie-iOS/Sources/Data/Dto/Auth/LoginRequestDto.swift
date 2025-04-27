//
//  LoginRequestDto.swift
//  Walkie-iOS
//
//  Created by ahra on 4/26/25.
//

enum LoginType {
    case kakao
    case apple
    
    var rawValue: String {
        switch self {
        case .kakao:
            return "kakao"
        case .apple:
            return "apple"
        }
    }
}

struct LoginRequestDto {
    let provider: LoginType
    let token: String
}
