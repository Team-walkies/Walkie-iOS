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
        requestAuthorization()
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
    
    /// 로컬 푸시 알림 스케줄링 (즉시 또는 특정 시간)
    func scheduleNotification(title: String, body: String) {
        /// 알림 송신 조건
        /// 1. 아직 알림을 보내지 않았음
        /// 2. 부화 알림 권한 허용
        /// 3. 앱 알림 권한 허용
        if let notified = notified, !notified {
            if NotificationManager.shared.getNotificationMode() {
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
                
                // 알림 요청
                UNUserNotificationCenter.current().add(request)
                
                // 알림 요청 완료 플래그
                self.notified = true
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
    func checkNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized:
                    completion(true)
                default:
                    self.notifyEggHatch = false
                    completion(false)
                }
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
            return "어서 가서 깨워주세요"
        }
    }
}
