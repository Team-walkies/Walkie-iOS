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
    
    @UserDefaultsWrapper<String>(key: "userNickname") private(set) var userNickname
    @UserDefaultsWrapper<Bool>(key: "tapStart") private(set) var tapStart
    
    private init() {}
}

extension UserManager {
    
    var isUserLogin: Bool { return TokenKeychainManager.shared.hasToken() }
    var hasUserNickname: Bool { return self.userNickname != nil }
    var getUserNickname: String { return self.userNickname ?? ""}
    var isTapStart: Bool { return self.tapStart ?? false }
}

extension UserManager {
    
    func setTapStart() {
        self.tapStart = true
    }
    
    func setUserNickname(_ nickname: String) {
        self.userNickname = nickname
    }
}
