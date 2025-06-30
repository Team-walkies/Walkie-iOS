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
    @UserDefaultsWrapper<Date>(key: "startExploreDate") private(set) var startExploreDate
    @UserDefaultsWrapper<Date>(key: "lastVisitedDate") private(set) var lastVisitedDate
    
    private init() {}
}

extension UserManager {
    
    var hasUserToken: Bool { return TokenKeychainManager.shared.hasToken() }
    var getUserNickname: String { return self.nickname ?? "" }
    var getStartExploreDate: Date? { return self.startExploreDate }
    var getLastVisitedDate: Date? { return self.lastVisitedDate }
}

extension UserManager {
    
    func setUserNickname(_ nickname: String) {
        self.nickname = nickname
    }
    
    func setStartExploreDate(_ date: Date) {
        self.startExploreDate = date
    }
    
    func setLastVisitedDate(_ date: Date) {
        self.lastVisitedDate = date
    }
    
    func clearExploreDate() {
        self.startExploreDate = nil
    }
    
    func withdraw() {
        do {
            try TokenKeychainManager.shared.removeTokens()
        } catch {

        }
        nickname = nil
    }
}
