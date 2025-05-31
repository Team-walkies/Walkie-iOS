//
//  MypageItemEnum.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/21/25.
//

import SwiftUI

protocol MypageSectionItem {
    var title: String { get }
    var icon: Image { get }
    var hasNavigation: Bool { get }
}

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

enum MypageSettingSectionItem: MypageSectionItem {
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
    
    var hasNavigation: Bool {
        return true
    }
}

enum MypageServiceSectionItem: MypageSectionItem {
    case notice
    case privacyPolicy
    case servicePolicy
    case appVersion
    
    var title: String {
        switch self {
        case .notice:
            return "공지사항"
        case .privacyPolicy:
            return "개인정보처리방침"
        case .appVersion:
            return "앱 버전"
        case .servicePolicy:
            return "서비스 이용 약관"
        }
    }
    
    var icon: Image {
        switch self {
        case .notice:
            return Image(.icMyNotice)
        case .privacyPolicy:
            return Image(.icMyPrivacy)
        case .servicePolicy:
            return Image(.icMyService)
        case .appVersion:
            return Image(.icMyVersion)
        }
    }
    
    var hasNavigation: Bool {
        switch self {
        case .appVersion:
            return false
        default:
            return true
        }
    }
}
