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
    @UserDefaultsWrapper<Bool>(key: "notified") var notified
    
    init() {
        /// 초깃값 설정
        if notified == nil {
            notified = false
        }
    }
    
    func getNotificationMode() -> Bool {
        guard let notifyEggHatch else {
            checkNotificationPermission { _ in
                return
            }
            return false
        }
        return notifyEggHatch
    }
    
    func toggleNotificationMode() {
        guard let notifyEggHatch else {
            return
        }
        self.notifyEggHatch = !notifyEggHatch
    }
    
    /// 알림 권한 요청
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, _ in
            // 앱 알림 비허용 설정 반영
            if !granted { self.notifyEggHatch = false }
            return completion(granted)
        }
    }
    
    /// 로컬 푸시 알림 스케줄링 (즉시 또는 특정 시간)
    func scheduleNotification(title: String, body: String) {
        let identifier = UUID().uuidString
        
        // 내용
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        
        // 10초 후
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        // 알림 요청 생성
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        /// 알림 송신 조건
        /// 1. 아직 알림을 보내지 않았음
        /// 2. 부화 알림 권한 허용
        /// 3. 앱 알림 권한 허용
        if let notified = notified {
            if !notified {
                NotificationManager.shared.requestAuthorization { granted in
                    if granted && NotificationManager.shared.getNotificationMode() {
                        UNUserNotificationCenter.current().add(request) { error in
                            if let error = error {
                                print("🛎️ 알림 전송 스케줄링 실패 : \(error.localizedDescription)🛎️")
                            } else {
                                print("🛎️ 알림 전송 완료 \(identifier)🛎️")
                            }
                        }
                        self.notified = true
                    }
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
    
    func checkNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized, .provisional:
                    self.notifyEggHatch = true
                default:
                    self.notifyEggHatch = false
                    completion(false)
                }
            }
        }
    }
}

enum NotificationLiterals {
    case eggHatch
    
    var title: String {
        switch self {
        case .eggHatch:
            return "알이 부화하려고 해요!"
        }
    }
    
    var body: String {
        switch self {
        case .eggHatch:
            return "어서 가서 꺠워주세요"
        }
    }
}
