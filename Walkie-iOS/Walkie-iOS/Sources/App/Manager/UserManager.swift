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
    
    @UserDefaultsWrapper<String>(key: "nickname") private(set) var nickname
    
    private init() {}
}

extension UserManager {
    
    var hasUserToken: Bool { return TokenKeychainManager.shared.hasToken() }
    var getUserNickname: String { return self.nickname ?? "" }
}

extension UserManager {
    
    func setUserNickname(_ nickname: String) {
        self.nickname = nickname
    }
    
    func withdraw() {
        do {
            try TokenKeychainManager.shared.removeTokens()
        } catch {

        }
    }
}
