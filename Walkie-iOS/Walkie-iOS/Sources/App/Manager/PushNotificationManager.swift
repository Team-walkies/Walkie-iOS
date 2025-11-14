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
        guard let notifyEggHatch else {
            checkNotificationPermission { _ in
                return
            }
            return false
        }
        return notifyEggHatch
    }
    
    func setNotificationMode(_ mode: Bool) {
        self.notifyEggHatch = mode
    }
    
    /// 알림 권한 요청 (최초 1회)
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: options) { granted, _ in
                // 앱 알림 허용 설정 반영
                self.notifyEggHatch = granted
            }
    }
    
    func scheduleNotification(title: String, body: String, type: NotificationType = .eggHatch) {
        guard getNotificationMode() else {
            print("🛎️ 알림 권한 없음 🛎️")
            return
        }
        
        if type == .eggHatch {
            if UserManager.shared.hasNotifiedEggHatch() {
                return
            }
        } else if type == .stepGoal {
            if UserManager.shared.hasNotifiedStepGoalToday() {
                return
            }
        }
        
        let identifier = type == .eggHatch ? UUID().uuidString : "step-goal-\(Date().timeIntervalSince1970)"
        let timeInterval = type == .eggHatch ? 10.0 : 1.0
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("🛎️ 알림 전송 실패: \(error.localizedDescription) 🛎️")
            } else {
                if type == .eggHatch {
                    UserManager.shared.markEggHatchNotificationSent()
                } else {
                    UserManager.shared.markStepGoalNotificationSent()
                }
            }
        }
    }
    
    func clearBadge() {
        UNUserNotificationCenter.current().setBadgeCount(0) { error in
            if let error = error {
                print("🛎️ 알림 뱃지 초기화 실패 \(error.localizedDescription)🛎️")
            } else {
                print("🛎️ 알림 뱃지 초기화 완료 🛎️")
            }
        }
    }
    
    /// 앱 푸시알림 권한 확인
    func checkNotificationPermission(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }
    
    func isNotificationNotDetermined(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .notDetermined)
            }
        }
    }
    
    func isNotificationDenied(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .denied)
            }
        }
    }
    
    /// 설정창 리디렉션
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(
                url,
                options: [:],
                completionHandler: nil
            )
        }
    }
}

enum NotificationType {
    case eggHatch
    case stepGoal
    
    var title: String {
        switch self {
        case .eggHatch:
            return "알이 부화하려고 해요!"
        case .stepGoal:
            return "목표 걸음 수를 채웠어요!"
        }
    }
    
    var body: String {
        switch self {
        case .eggHatch:
            return "어서 가서 깨워주세요"
        case .stepGoal:
            return "지금 바로 알을 얻어보세요"
        }
    }
}
