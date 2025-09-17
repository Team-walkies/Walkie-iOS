//
//  UserManager.swift
//  Walkie-iOS
//
//  Created by ahra on 3/5/25.
//

import SwiftUI

enum DefaultsKey {
    static let targetStep = "targetStep"
}

final class UserManager {
    
    static let shared = UserManager()
    
    // MARK: - Properties
    @UserDefaultsWrapper<String>(key: "nickname") private(set) var nickname
    @UserDefaultsWrapper<Date>(key: "startExploreDate") private(set) var startExploreDate
    @UserDefaultsWrapper<Date>(key: "lastVisitedDate") private(set) var lastVisitedDate
    @UserDefaultsWrapper<Bool>(key: "showHealthcare") private(set) var showHealthcare
    @UserDefaultsWrapper<Date>(key: "receiveTodayDate") private(set) var receiveTodayDate
    @UserDefaultsWrapper<Bool>(key: "receiveTodayEgg") private(set) var receiveTodayEgg
    
    private init() {}
}

extension UserManager {
    
    var hasUserToken: Bool { return TokenKeychainManager.shared.hasToken() }
    var getUserNickname: String { return self.nickname ?? "" }
    var getStartExploreDate: Date? { return self.startExploreDate }
    var getLastVisitedDate: Date? { return self.lastVisitedDate }
    var getShowHealthcare: Bool { return self.showHealthcare ?? false }
    var getTargetStep: Int {
        let targetStep = UserDefaults.standard.integer(forKey: DefaultsKey.targetStep)
        return targetStep == 0 ? 6000 : targetStep
    }
    var getReceiveTodayEgg: Bool {
        normalizeDay()
        return receiveTodayEgg ?? false
    }
}

extension UserManager {
    
    func setUserNickname(_ nickname: String) {
        self.nickname = nickname
    }
    
    func setStartExploreDate(_ date: Date) {
        startExploreDate = date
    }
    
    func setLastVisitedDate(_ date: Date) {
        lastVisitedDate = date
    }
    
    func setTargetStep(_ step: Int) {
        UserDefaults.standard.set(step, forKey: DefaultsKey.targetStep)
    }
    
    func setShowHealthcare() {
        showHealthcare = true
    }
    
    func setReceiveTodayEgg() {
        receiveTodayEgg = true
        receiveTodayDate = Date().kstStartOfDay
    }
    
    func clearExploreDate() {
        startExploreDate = nil
    }
    
    func withdraw() {
        do {
            try TokenKeychainManager.shared.removeTokens()
        } catch {

        }
        showHealthcare = false
        nickname = nil
    }
}

private extension UserManager {
    
    func normalizeDay() {
        guard let savedDay = receiveTodayDate else {
            if receiveTodayEgg == true {
                receiveTodayEgg = false
            }
            return
        }
        
        if !savedDay.isTodayKST {
            receiveTodayEgg = false
            receiveTodayDate = Date().kstStartOfDay
        }
    }
}
