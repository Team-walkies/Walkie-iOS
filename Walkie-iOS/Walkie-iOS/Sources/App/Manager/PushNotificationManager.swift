//
//  PushNotificationManager.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/5/25.
//

import NotificationCenter

final class NotificationManager {
    static let shared = NotificationManager()
    
    @UserDefaultsWrapper<Bool>(key: "notifyEggHatch") private var notifyEggHatch
    
    func getNotificationMode() -> Bool {
        return notifyEggHatch ?? false
    }
    
    func toggleNotificationMode() {
        guard let notifyEggHatch else { return }
        self.notifyEggHatch = !notifyEggHatch
    }
    
    /// 알림 권한 요청
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print("ERROR: \(error)")
            } else {
                print("SUCCESS: Notification authorization granted")
            }
        }
    }
    
    /// 로컬 푸시 알림 스케줄링 (즉시 또는 특정 시간)
    func scheduleNotification(identifier: String, title: String, body: String, triggerDate: Date? = nil) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        
        // 트리거 설정: triggerDate가 nil이면 즉시 알림
        let trigger: UNNotificationTrigger
        if let date = triggerDate {
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        } else {
            // 즉시 알림 (1초 후)
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        }
        
        // 알림 요청 생성
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // 알림 센터에 추가
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("ERROR: Failed to schedule notification - \(error)")
            } else {
                print("SUCCESS: Notification scheduled with identifier \(identifier)")
            }
        }
    }
    
    /// 기존 알림 제거
    func removeScheduledNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
