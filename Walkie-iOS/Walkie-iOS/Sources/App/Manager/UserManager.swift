//
//  UserManager.swift
//  Walkie-iOS
//
//  Created by ahra on 3/5/25.
//

import SwiftUI

final class UserManager {
    
    static let shared = UserManager()
    
    // MARK: - Properties
    
    @UserDefaultsWrapper<String>(key: "provider") private(set) var provider
    @UserDefaultsWrapper<String>(key: "socialToken") private(set) var socialToken
    @UserDefaultsWrapper<String>(key: "userNickname") private(set) var userNickname
    @UserDefaultsWrapper<Bool>(key: "tapStart") private(set) var tapStart
    
    private init() {}
}

extension UserManager {
    
    var isUserLogin: Bool { return TokenKeychainManager.shared.hasToken() }
    var getSocialProvider: String { return provider ?? "" }
    var getSocialToken: String { return socialToken ?? ""}
    var hasTapLogin: Bool { return self.socialToken != nil }
    var hasUserNickname: Bool { return self.userNickname != "" }
    var getUserNickname: String { return self.userNickname ?? ""}
    var isTapStart: Bool { return self.tapStart ?? false }
}

extension UserManager {
    
    func setSocialLogin(
        request: LoginRequestDto
    ) {
        self.provider = request.provider.rawValue
        self.socialToken = request.token
    }
    
    func setTapStart() {
        self.tapStart = true
    }
    
    func setUserNickname(_ nickname: String) {
        self.userNickname = nickname
    }
    
    func withdraw() {
        do {
            try TokenKeychainManager.shared.removeTokens()
        } catch {
            
        }
        provider = .none
        socialToken = ""
        userNickname = ""
        tapStart = false
    }
}
