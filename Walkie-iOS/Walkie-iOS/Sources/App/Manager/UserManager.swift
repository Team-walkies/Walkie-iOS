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
    @UserDefaultsWrapper<Date>(key: "lastNotifiedHealthCareDate") var lastNotifiedHealthCareDate
    @UserDefaultsWrapper<Bool>(key: "notifiedEggHatch") private var notifiedEggHatch
    
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
        // 목표 걸음 수가 변경되면 오늘 알림 여부 초기화
        // 새로운 목표에 대해 다시 알림을 받을 수 있도록 함
        self.lastNotifiedHealthCareDate = nil
    }
    
    /// 목표 걸음 달성 알림을 오늘 보냈는지 확인
    func hasNotifiedStepGoalToday() -> Bool {
        guard let lastNotifiedDate = lastNotifiedHealthCareDate else {
            return false
        }
        return lastNotifiedDate.isToday()
    }
    
    /// 목표 걸음 달성 알림 날짜 기록
    func markStepGoalNotificationSent() {
        lastNotifiedHealthCareDate = Date()
    }
    
    /// 부화 알림을 보냈는지 확인
    func hasNotifiedEggHatch() -> Bool {
        return notifiedEggHatch ?? false
    }
    
    /// 부화 알림 전송 완료 표시
    func markEggHatchNotificationSent() {
        notifiedEggHatch = true
    }
    
    func setShowHealthcare() {
        showHealthcare = true
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
        notifiedEggHatch = nil
    }
}
