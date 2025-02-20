//
//  MypageItemEnum.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/21/25.
//

import SwiftUI

enum MypageItem {
    case setting
    case service
    
    var title: String {
        switch self {
        case .setting:
            return "설정"
        case .service:
            return "서비스 약관"
        }
    }
}

enum MypageSettingSectionItem {
    case myInfo
    case pushNotification
    
    var title: String {
        switch self {
        case .myInfo:
            return "내 정보"
        case .pushNotification:
            return "푸시 알림"
        }
    }
    
    var icon: Image {
        switch self {
        case .myInfo:
            return Image(.icMySetting)
        case .pushNotification:
            return Image(.icMyAlarm)
        }
    }
    
    var action: () -> Void {
        switch self {
        case .myInfo:
            // 내 정보 이동
            return {}
        case .pushNotification:
            // 푸시 알림 이동
            return {}
        }
    }
}

enum MypageServiceSectionItem {
    case notice
    case privacyPolicy
    case appVersion
    
    var title: String {
        switch self {
        case .notice:
            return "공지사항"
        case .privacyPolicy:
            return "개인정보처리방침"
        case .appVersion:
            return "앱 버전"
        }
    }
    
    var icon: Image {
        switch self {
        case .notice:
            return Image(.icMyNotice)
        case .privacyPolicy:
            return Image(.icMyPrivacy)
        case .appVersion:
            return Image(.icMyVersion)
        }
    }
    
    var action: () -> Void {
        switch self {
        case .notice:
            // 공지사항 이동
            return {}
        case .privacyPolicy:
            // 개인정보처리방침 이동
            return {}
        case .appVersion:
            return {}
        }
    }
}
