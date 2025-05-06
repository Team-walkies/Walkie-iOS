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
    @UserDefaultsWrapper<Int>(key: "stepCount") private(set) var stepCount
    @UserDefaultsWrapper<Int>(key: "stepCountGoal") private(set) var stepCountGoal
    
    private init() {}
}

extension UserManager {
    
    var hasUserToken: Bool { return TokenKeychainManager.shared.hasToken() }
    var getUserNickname: String { return self.nickname ?? "" }
    var getStepCount: Int { return self.stepCount ?? 0 }
    var getStepCountGoal: Int { return self.stepCountGoal ?? .max }
}

extension UserManager {
    
    func setUserNickname(_ nickname: String) {
        self.nickname = nickname
    }
    
    func setStepCount(_ count: Int) {
        self.stepCount = count
    }
    
    func setStepCountGoal(_ count: Int) {
        self.stepCountGoal = count
    }
    
    func withdraw() {
        do {
            try TokenKeychainManager.shared.removeTokens()
        } catch {

        }
        nickname = nil
    }
}
