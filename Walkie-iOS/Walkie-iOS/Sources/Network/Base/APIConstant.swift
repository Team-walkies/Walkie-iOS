//
//  APIConstant.swift
//  Walkie-iOS
//
//  Created by ahra on 3/11/25.
//

import Foundation

enum NetworkHeaderKey: String {
    
    case contentType = "Content-Type"
    case authorization = "Authorization"
}

enum APIConstants {
    
    // MARK: - Header
    
    static var noTokenHeader: [String: String] {
        [
            NetworkHeaderKey.contentType.rawValue: "application/json"
        ]
    }
    
    static var hasTokenHeader: [String: String] {
        let token = Config.testToken
        return [
            NetworkHeaderKey.contentType.rawValue: "application/json",
            NetworkHeaderKey.authorization.rawValue: "Bearer \(token)"
        ]
    }
    
    static var hasRefreshTokenHeader: [String: String] {
        let token = (try? TokenKeychainManager.shared.getRefreshToken()) ?? ""
        return [
            NetworkHeaderKey.contentType.rawValue: "application/json",
            NetworkHeaderKey.authorization.rawValue: "Bearer \(token)"
        ]
    }
}
